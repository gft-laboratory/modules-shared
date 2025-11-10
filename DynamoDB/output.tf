output "dynamodb_table_id" {
  description = "The ID of the DynamoDB table"
  value       = aws_dynamodb_table.dynamodb_table.id
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.dynamodb_table.name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.dynamodb_table.arn
}

# --- DynamoDB Native Stream Outputs ---

output "dynamodb_table_stream_arn" {
  description = "The ARN of the native DynamoDB Stream (if enabled)"
  value       = var.dynamodb_stream_enabled ? aws_dynamodb_table.dynamodb_table.stream_arn : null
}

output "dynamodb_table_stream_label" {
  description = "The label of the native DynamoDB Stream (if enabled)"
  value       = var.dynamodb_stream_enabled ? aws_dynamodb_table.dynamodb_table.stream_label : null
}

# --- Kinesis Stream Outputs ---

output "kinesis_stream_arn" {
  description = "ARN of the Kinesis stream (if created)"
  value       = var.kinesis_stream_enabled ? aws_kinesis_stream.this[0].arn : null
}

output "kinesis_stream_name" {
  description = "Name of the Kinesis stream (if created)"
  value       = var.kinesis_stream_enabled ? aws_kinesis_stream.this[0].name : null
}
