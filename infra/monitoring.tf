terraform {
  required_providers {
    google = { source = "hashicorp/google", version = "~> 5.40" }
  }
}

provider "google" {
  project = var.project_id
}

variable "project_id" { type = string }
variable "notification_channels" { type = list(string), default = [] }

locals {
  targets = [
    { name = "admin",      host = "admin.app-oint.com" },
    { name = "business",   host = "business.app-oint.com" },
    { name = "enterprise", host = "enterprise.app-oint.com" },
  ]
}

resource "REDACTED_TOKEN" "healthz" {
  for_each    = { for t in local.targets : t.name => t }
  display_name = "uptime-${each.key}"
  timeout      = "10s"
  period       = "60s"

  http_check {
    path         = "/api/healthz"
    port         = 443
    use_ssl      = true
    validate_ssl = true
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project_id
      host       = each.value.host
    }
  }
}

resource "google_monitoring_alert_policy" "uptime_alert" {
  display_name = "Uptime Down"
  combiner     = "OR"

  conditions {
    display_name = "Uptime failure"
    condition_threshold {
      filter          = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\""
      comparison      = "COMPARISON_LT"
      threshold_value = 1
      duration        = "120s"
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  notification_channels = var.notification_channels
}



