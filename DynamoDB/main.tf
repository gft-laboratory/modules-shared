resource "aws_dynamodb_table" "dynamodb_table" {
  # checkov:skip=CKV_AWS_28: PITR disable by customer definition because it is used by demand. Optional.
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = var.partition_key_name
  # Define sort_key no recurso se informado
  range_key      = var.sort_key_name != null ? var.sort_key_name : null

  # Partition key
  attribute {
    name = var.partition_key_name
    type = var.partition_key_type
  }

  # Sort key opcional
  dynamic "attribute" {
    for_each = var.sort_key_name != null && var.sort_key_type != null ? [1] : []
    content {
      name = var.sort_key_name
      type = var.sort_key_type
    }
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery_enabled
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = var.kms_key_arn
  }

  # Optional stream
  stream_enabled   = var.dynamodb_stream_enabled
  stream_view_type = var.dynamodb_stream_enabled ? var.stream_view_type : null

  lifecycle {
    precondition {
      condition     = !(var.dynamodb_stream_enabled && var.stream_view_type == null)
      error_message = "stream_view_type deve ser definido quando stream_enabled for true."
    }
  }

  tags = var.tags_dynamodb
}

# Optional when enabled stream
resource "aws_kinesis_stream" "this" {
  count = var.kinesis_stream_enabled ? 1 : 0

  name = var.kinesis_stream_name != null ? var.kinesis_stream_name : "${var.table_name}-stream"
  shard_count      = var.kinesis_shard_count
  retention_period = var.kinesis_retention_period
  encryption_type  = var.encryption_type
  kms_key_id = var.kms_key_arn != null ? var.kms_key_arn : null
}

resource "aws_dynamodb_kinesis_streaming_destination" "this_streaming_destination" {
  count = var.kinesis_stream_enabled ? 1 : 0

  table_name = aws_dynamodb_table.dynamodb_table.name
  stream_arn = aws_kinesis_stream.this[0].arn
}
