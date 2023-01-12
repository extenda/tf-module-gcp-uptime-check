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
This variable should contain the actual list of uptime check configurations, and should be structured as shown below. \
📖 [Terraform Docs](https://registry.terraform.io/providers/hashicorp/google/4.47.0/docs/resources/monitoring_uptime_check_config) \
✅ [Examples](./examples/)

```hcl
uptime_checks = [
  {
    service_name          = string           // () : Name of the service.
    display_name          = optional(string) // (service_name) : Name of the uptime check
    project               = string           // () : Project-id to where to create the uptime check
    timeout               = optional(string) // (see main.tf) : The maximum amount of time to wait for the request to complete 
    period                = optional(string) // (see main.tf) : How often, in seconds, the uptime check is performed. 
    selected_regions      = optional(string) // (see main.tf) : Check terraform
    path                  = optional(string) // (/health) : The path to the page to run the check against.
    check_type            = optional(string) // (HTTPS) - [HTTPS, HTTP] :
    headers               = optional(map())  // ({}) :
    request_method        = optional(string) // (GET) :
    body                  = optional(string) // () : The request body associated with the HTTP POST request. If contentType is URL_ENCODED, the body passed in must be URL-encoded. 
    content_type          = optional(string) // () [URL_ENCODED, TYPE_UNSPECIFIED]
    username              = optional(string) // () :
    password              = optional(string) // () :
    type                  = optional(string) // (uptime_url) :
    accepted_status_class = optional(string) // (STATUS_CLASS_2XX) :

    content_matchers = optional(object({
      content = string           // () :  String or regex content to match (max 1024 bytes)
      matcher = optional(string) // () :  Check terraform docs for available arguments.

      json_matcher = optional(object({
        json_path    = string           // () : JSON-path within the response to match against.
        json_matcher = optional(string) // () - [EXACT_MATCH, REGEX_MATCH] :
      }))

    }))

    alert = object({
      display_name          = optional(string)       // () : Name of the alert
      enabled               = optional(string)       // (true) : Whether or not the policy is enabled
      notification_channels = optional([string])     // ():  List of NCs to be set for the alert. Provide the NCs "full p ath" or "display name".
      duration              = optional(string)       // (120s) : The time that a time series must violate the threshold.
      threshold_value       = optional(number)       // (1) : A value against which to compare the time series.
      trigger               = optional(string)       // (1) : When to trigger the alert.
      comparison            = optional(string)       // (COMPARISON_GT) - [COMPARISON_GT, COMPARISON_LT] : When to trigger the alert.
      alignment_period      = optional(string)       // () : Period for per-time series alignment. 
      notification_channels = optional(list(string)) // (fallback_notification_channels) : List of NCs to be set for the alert. Provide the NCs "id" or "display name".
    })

  },
]
```

## Outputs

| Name               | Description                                  |
| ------------------ | -------------------------------------------- |
| uptime_check_ids   | The id of the uptime check                   |
| uptime_check_names | A unique resource name for UptimeCheckConfig |
