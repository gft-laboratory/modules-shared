output "step_function_arn" {
  description = "ARN da Step Function"
  value       = aws_sfn_state_machine.this.arn
}

output "step_function_name" {
  description = "Nome da Step Function"
  value       = aws_sfn_state_machine.this.name
}

output "step_function_id" {
  description = "ID da Step Function"
  value       = aws_sfn_state_machine.this.id
}
