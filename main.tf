resource "aws_s3_bucket" "demo" {
  bucket = var.bucket_name

# v3 inline lifecycle rule (REMOVED in v4+)
  lifecycle_rule {
    id      = "expire-old"
    enabled = true
    expiration {
      days = 30
    }
  }

  # v3 inline logging (REMOVED in v4+)
  logging {
    target_bucket = var.bucket_name
    target_prefix = "logs/"
  }
}
