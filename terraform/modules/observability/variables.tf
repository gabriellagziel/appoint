variable "namespace" {
  description = "Kubernetes namespace for observability components"
  type        = string
}

variable "metrics_retention_days" {
  description = "Retention time for Prometheus metrics in days"
  type        = number
}

variable "trace_retention_days" {
  description = "Retention time for traces in days"
  type        = number
}
