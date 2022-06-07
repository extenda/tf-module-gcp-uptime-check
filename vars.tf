variable tribe_project_id {
  type        = string
  description = "Project ID where the Monitoring resources will be created"
}

variable clan_project_id {
  type        = string
  description = "Clan Project ID"
}

variable clan_name {
  type        = string
  description = "The name of the clan"
}

variable uptimecheck_monitoring {
  type        = bool
  description = "If the uptime check should be created"
  default     = false
}

variable display_name {
  type        = string
  description = "Human-friendly name for the uptime check configuration."
}

variable host {
  type        = string
  description = "Host for uptime check"
}