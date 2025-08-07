resource "aws_s3_bucket" "logs" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_lifecycle_configuration" "log_lifecycle" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id     = "log-retention"
    status = "Enabled"

    expiration {
      days = var.log_retention_period
    }
  }
}
