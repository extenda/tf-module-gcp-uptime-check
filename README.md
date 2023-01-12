## Inputs

| Name                           | Description                                            | Type           | Default | Required |
| ------------------------------ | ------------------------------------------------------ | -------------- | ------- | :------: |
| project                        | Project ID to create monitoring resources in           | `string`       | n/a     | __yes__  |
| default_alert_project          | Optional: if you want the alert inside another project | `string`       | n/a     |    no    |
| default_user_labels            |                                                        | `string`       | n/a     |    no    |
| fallback_notification_channels |                                                        | `list(string)` | n/a     |    no    |
| notification_channel_ids       |                                                        | `map(string)`  | n/a     |    no    |
| uptime_checks                  | The list of uptime checks configurations               | `object(any)`  | n/a     | __yes__  |

__uptime_checks__ supported attributes:

```hcl
uptime_checks = [
  {
    service_name          = string           // () :
    display_name          = optional(string) // (service_name) :
    project               = string           // () :
    timeout               = optional(string) // () : 
    period                = optional(string) // () :
    selected_regions      = optional(string) // () :
    path                  = optional(string) // (/health) : 
    check_type            = optional(string) // (HTTPS) - [HTTPS, HTTP] :
    headers               = optional(string) // () :
    request_method        = optional(string) // (GET) 
    body                  = optional(string) // () : The request body associated with the HTTP POST request. If contentType is URL_ENCODED, the body passed in must be URL-encoded. 
    content_type          = optional(string) // () [URL_ENCODED, TYPE_UNSPECIFIED]
    username              = optional(string) // () :
    password              = optional(string) // () :
    type                  = optional(string) // (uptime_url) :
    accepted_status_class = optional(string) // (STATUS_CLASS_2XX) 

    content_matchers = optional(object({
      content = string           // () :  String or regex content to match (max 1024 bytes)
      matcher = optional(string) // () :

      json_matcher = optional(object({
        json_path    = string           // () : 
        json_matcher = optional(string) // () - [EXACT_MATCH, REGEX_MATCH] 
      }))

    }))

    alert = object({
      display_name          = optional(string)       // () : 
      enabled               = optional(string)       // (true) : 
      notificaiton_channels = optional(list())       // () :
      duration              = optional(string)       // (120s) : 
      threshold_value       = optional(number)       // (1) :
      comparison            = optional(string)       // (1) :
      alignment_period      = optional(string)       // (COMPARISON_GT) : 
      notification_channels = optional(list(string)) // () : 
    })

  },
]
```

## Outputs

| Name               | Description                                  |
| ------------------ | -------------------------------------------- |
| uptime_check_ids   | The id of the uptime check                   |
| uptime_check_names | A unique resource name for UptimeCheckConfig |
