module "uptime-check" {
  source        = "../"
  project       = "monitoring-project-id"
  uptime_checks = yamldecode(file("uptime-checks.yaml"))
  default_user_labels = {
    clan = "sre",
    cc   = "1337"
  }
}
