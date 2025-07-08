resource "aws_kms_key" "this" {
  description             = var.description
  enable_key_rotation     = var.enable_key_rotation
  is_enabled              = var.is_enabled
  deletion_window_in_days = var.deletion_window_in_days
  policy                  = var.kms_policy != null ? var.kms_policy : null
  multi_region            = var.multi_region

  tags = var.tags
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.alias}"
  target_key_id = aws_kms_key.this.key_id
}
