output "secret_id" {
  description = "ID do segredo criado"
  value       = aws_secretsmanager_secret.this.id
}

output "secret_arn" {
  description = "ARN do segredo"
  value       = aws_secretsmanager_secret.this.arn
}

output "secret_name" {
  description = "Nome do segredo"
  value       = aws_secretsmanager_secret.this.name
}
