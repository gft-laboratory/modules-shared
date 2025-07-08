resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.bucket_name}"

  tags   = var.tags_bucket
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  count = var.create_bucket_policy ? 1 : 0

  bucket = aws_s3_bucket.s3_bucket.bucket
  policy = templatefile("${path.module}/json_policy/bucket_policy.json", {
    bucket_name = var.bucket_name
    environment = var.environment
  })
}

// enabling log to bucket send logs to other bucket to this

resource "aws_s3_bucket_logging" "logging_bucket" {
  count = var.bucket_log_name != "" ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id

  target_bucket = var.bucket_log_name
  target_prefix = "log/"

  depends_on = [ aws_s3_bucket.s3_bucket ]
}

resource "aws_s3_bucket_public_access_block" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [ aws_s3_bucket.s3_bucket ]
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle" {
  count  = var.create_lifecycle ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = "Enabled"

      expiration {
        days = rule.value.expiration
      }

      filter {
        prefix = rule.value.prefix
      }

      dynamic "transition" {
        for_each = rule.value.transitions
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      noncurrent_version_expiration {
        noncurrent_days = rule.value.noncurrent_version_expiration
      }

      dynamic "noncurrent_version_transition" {
        for_each = rule.value.noncurrent_version_transitions
        content {
          noncurrent_days = noncurrent_version_transitions.value.noncurrent_days
          storage_class   = noncurrent_version_transitions.value.storage_class
        }
      }
    }
  }
}