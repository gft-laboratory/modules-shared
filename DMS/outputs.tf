output "replication_instance_arn" {
  value = aws_dms_replication_instance.this.replication_instance_arn
}

output "source_endpoint_arn" {
  value = aws_dms_endpoint.source.endpoint_arn
}

output "target_endpoint_arn" {
  value = aws_dms_endpoint.target.endpoint_arn
}

output "replication_task_arn" {
  value = aws_dms_replication_task.this.replication_task_arn
}