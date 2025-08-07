variable "namespace" {
  description = "Namespace where alert rules will be created"
  type        = string
}

variable "api_availability_slo_percent" {
  description = "Target uptime percentage for API"
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
