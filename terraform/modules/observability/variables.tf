variable "namespace" {
  description = "Kubernetes namespace for observability components"
  type        = string
}

variable "metrics_retention_period" {
  description = "Prometheus metrics retention period (e.g. 14d)"
  type        = string
}

variable "trace_retention_period" {
  description = "Trace retention period (e.g. 7d)"
  type        = string
}
