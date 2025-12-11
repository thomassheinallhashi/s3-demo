resource "aws_s3_bucket" "demo" {
  bucket = var.bucket_name

  versioning {               # ✅ valid on v3
    enabled = true
  }
}
