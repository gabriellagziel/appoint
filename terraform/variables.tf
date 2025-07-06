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

variable "metrics_retention_days" {
  description = "Prometheus metrics retention period in days"
  type        = number
}

variable "trace_retention_days" {
  description = "Trace retention period in days"
  type        = number
}

variable "log_bucket_name" {
  description = "S3 bucket name for logs"
  type        = string
}

variable "log_retention_days" {
  description = "Log retention period in days"
  type        = number
}

variable "api_uptime_target" {
  description = "Uptime threshold percentage for API availability"
  type        = number
}

variable "api_p95_latency_ms" {
  description = "Alert threshold for p95 latency in milliseconds"
  type        = number
}

variable "api_p99_latency_ms" {
  description = "Alert threshold for p99 latency in milliseconds"
  type        = number
}

variable "booking_success_target" {
  description = "Booking success rate threshold percentage"
  type        = number
}
