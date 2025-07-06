variable "bucket_name" {
  description = "Name of the S3 bucket for logs"
  type        = string
}

variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
}
