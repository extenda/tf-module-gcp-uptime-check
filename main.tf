locals {
  default_timeout                = "10s"
  default_period                 = "300s"
  default_selected_regions       = ["EUROPE", "ASIA_PACIFIC", "SOUTH_AMERICA"]
  default_accepted_status_class  = "STATUS_CLASS_2XX"

  default_alert_duration         = "60s"
  default_alert_threshold_value  = 1
  default_alert_comparison       = "COMPARISON_GT"
  default_trigger                = 1
  default_alert_alignment_period = "1200s"

  fallback_notification_channels = [for nc in var.fallback_notification_channels : try(var.notification_channel_ids[nc], nc)]
}

resource "google_monitoring_uptime_check_config" "uptime_check_config" {
  for_each = { for i in var.uptime_checks : i.service_name => i }

  display_name = try(each.value.display_name, each.value.service_name)
  project      = try(each.value.project, var.project)
  timeout      = try(each.value.timeout, local.default_timeout)
  period       = try(each.value.period, local.default_period)

  selected_regions = try(each.value.selected_regions, local.default_selected_regions)

  http_check {
    path           = try(each.value.path, "/health")
    port           = try(each.value.check_type, "HTTPS") == "HTTP" ? "80" : "443"
    use_ssl        = try(each.value.check_type, "HTTPS") == "HTTP" ? false : true
    validate_ssl   = try(each.value.check_type, "HTTPS") == "HTTP" ? false : true
    request_method = try(each.value.request_method, "GET")
    content_type   = try(each.value.content_type, null)
    body           = try(each.value.body, null)
    headers        = try(each.value.headers, {})
    mask_headers   = try(each.value.headers, {}) == {} ? false : true

    dynamic "auth_info" {
      for_each = try([each.value.password], [])
      content {
        username = try(each.value.username, null)
        password = try(each.value.password, null)
      }
    }

    accepted_response_status_codes {
      status_class = try(each.value.status_class, local.default_accepted_status_class)
    }
  }

  monitored_resource {
    type = try(each.value.type, "uptime_url")
    labels = {
      project_id = var.project
      host       = try(each.value.hostname, null)
    }
  }

  dynamic "content_matchers" {
    for_each = try([each.value.content_matchers], [])
    content {
      content = try(content_matchers.value.content, null)
      matcher = try(content_matchers.value.matcher, null)
      json_path_matcher {
        json_path    = try(content_matchers.value.json_path, "")
        json_matcher = try(content_matchers.value.json_matcher, null)
      }
    }
  }
}

resource "google_monitoring_alert_policy" "uptime_check_alert_policy" {
  for_each = { for i in var.uptime_checks : i.service_name => i }

  project      = coalesce(var.default_alert_project, var.project)
  display_name = try(each.value.alert.display_name, "[P1] ${each.value.service_name} - Service is offline")
  enabled      = try(each.value.alert.enabled, true)
  combiner     = "OR"

  user_labels = merge(try(each.value.alert.user_labels, {}), var.default_user_labels)

  notification_channels = try(
    [for nc in each.value.alert.notificaiton_channels : try(var.notification_channel_ids[nc], nc)],
    local.fallback_notification_channels
  )

  conditions {
    display_name = "Failure of uptimecheck for ${each.value.service_name}"
    condition_threshold {
      duration        = try(each.value.alert.duration, local.default_alert_duration)
      threshold_value = try(each.value.alert.threshold_value, local.default_alert_threshold_value)
      comparison      = try(each.value.alert.comparison, local.default_alert_comparison)
      /* filter          = <<EOT
metric.type="monitoring.googleapis.com/uptime_check/check_passed" AND metric.label.check_id="${google_monitoring_uptime_check_config.uptime_check_config[each.value.service_name].uptime_check_id}" AND resource.type="uptime_url"
      EOT */
      filter          = <<EOT
        metric.type="monitoring.googleapis.com/uptime_check/check_passed"
        resource.type="uptime_url"
        metric.label.check_id="${google_monitoring_uptime_check_config.uptime_check_config[each.value.service_name].uptime_check_id}"
      EOT


      aggregations {
        alignment_period     = try(each.value.alert.alignment_period, local.default_alert_alignment_period)
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        per_series_aligner   = "ALIGN_NEXT_OLDER"
        group_by_fields      = ["resource.label.host"]
      }

      trigger {
        count = try(each.value.alert.trigger, local.default_alert_threshold_value)
      }
    }
  }

  depends_on = [google_monitoring_uptime_check_config.uptime_check_config]
}
