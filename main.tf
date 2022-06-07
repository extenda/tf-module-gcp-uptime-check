resource "google_monitoring_uptime_check_config" "https" {
  count = var.uptimecheck_monitoring ? 1 : 0

  project      = var.tribe_project_id
  display_name = var.display_name
  
  timeout      = "60s"

  http_check {
    path         = "/health" 
    port         = "443"
    use_ssl      = true
    validate_ssl = true
  }
  content = "\"outcome\":\"Up\""

  monitored_resource {
    type   = "uptime_url"
    labels = {
      host = var.host
    }
  }
}
