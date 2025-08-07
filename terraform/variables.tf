variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "kubeconfig_path" {
  description = "Path to Kubernetes config file"
  type        = string
  default     = "~/.kube/config"
}

variable "monitoring_namespace" {
  description = "Namespace for monitoring stack"
  type        = string
  default     = "monitoring"
}

variable "metrics_retention_period" {
  description = "Prometheus metrics retention period (e.g. 14d)"
  type        = string
}

variable "trace_retention_period" {
  description = "Trace retention period (e.g. 7d)"
  type        = string
}

variable "log_bucket_name" {
  description = "S3 bucket name for logs"
  type        = string
}

variable "log_retention_period" {
  description = "Log retention period in days"
  type        = number
}

variable "api_availability_slo_percent" {
  description = "Target uptime percentage for API availability"
  type        = number
}

variable "api_p95_latency_ms" {
  description = "p95 latency threshold in milliseconds"
  type        = number
}

variable "api_p99_latency_ms" {
  description = "p99 latency threshold in milliseconds"
  type        = number
}

variable "booking_success_slo_percent" {
  description = "Booking success rate threshold percentage"
  type        = number
}
