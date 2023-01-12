variable "project" {
  type        = string
  description = "Project ID to create the monitoring resources in"
}

variable "default_alert_project" {
  type        = string
  description = "Optional: if you want the alert inside another project"
  default     = ""
}

variable "default_user_labels" {
  type        = map(any)
  description = ""
  default     = {}
}

variable "fallback_notification_channels" {
  type        = list(any)
  description = "List of 'display names' or the IDs for NCs to be set for all alerts that don't provide 'notificaiton_channels'"
  default     = []
}

variable "notification_channel_ids" {
  type        = map(string)
  description = "To be able to provide the NCs display name instead of id/name, should be { display_name: name } or output from tf-module-gcp-notification-channels"
  default     = {}
}

variable "uptime_checks" {
  type        = any
  description = "The list of uptime checks configurations"
}
