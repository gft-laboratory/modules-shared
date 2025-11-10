output "lambda_function_name" {
  description = "Nome da função Lambda"
  value       = aws_lambda_function.this.function_name
}

output "lambda_function_arn" {
  description = "ARN da função Lambda"
  value       = aws_lambda_function.this.arn
}

output "lambda_invoke_arn" {
  description = "Invoke ARN da Lambda"
  value       = aws_lambda_function.this.invoke_arn
}