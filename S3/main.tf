resource "aws_s3_bucket" "s3_bucket" {
# checkov:skip=CKV_AWS_144: "Ensure that S3 bucket has cross-region replication enabled" not is obrigatory  
  bucket = var.bucket_name

  tags = var.tags_bucket
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_id
    }
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  count = var.create_bucket_policy ? 1 : 0

  bucket = aws_s3_bucket.s3_bucket.bucket
  policy = var.bucket_policy
}

resource "aws_s3_bucket_logging" "logging_bucket" {
  count = var.bucket_log_name != "" ? 1 : 0

  bucket        = aws_s3_bucket.s3_bucket.id
  target_bucket = var.bucket_log_name
  target_prefix = "log/"

  depends_on = [aws_s3_bucket.s3_bucket]
}

resource "aws_s3_bucket_public_access_block" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [aws_s3_bucket.s3_bucket]
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle" {
  # checkov:skip=CKV_AWS_300: It's enabled
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

      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.noncurrent_version_expiration != null ? [1] : []
        content {
          noncurrent_days = rule.value.noncurrent_version_expiration
        }
      }

      dynamic "abort_incomplete_multipart_upload" {
        for_each = rule.value.abort_incomplete_multipart_upload_days != null ? [1] : []
        content {
          days_after_initiation = rule.value.abort_incomplete_multipart_upload_days
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = rule.value.noncurrent_version_transitions
        content {
          noncurrent_days = noncurrent_version_transition.value.noncurrent_days
          storage_class   = try(noncurrent_version_transition.value.storage_class, null)
        }
      }

    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  count  = var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_notification" "this" {
  count  = var.enable_notification ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id

  lambda_function {
    lambda_function_arn = var.notification_lambda_arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = var.notification_prefix
    filter_suffix       = var.notification_suffix
  }

  depends_on = [aws_lambda_permission.allow_s3]
}

resource "aws_lambda_permission" "allow_s3" {
  count         = var.enable_notification ? 1 : 0
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = var.notification_lambda_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.s3_bucket.arn
}
