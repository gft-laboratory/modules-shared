output "datazone_domain_id" {
  description = "O ID do domínio Amazon DataZone criado."
  value       = aws_datazone_domain.main.id
}

output "datazone_project_id" {
  description = "O ID do projeto inicial criado."
  value       = aws_datazone_project.main.id
}

output "datazone_glossary_id" {
  description = "O ID do glossário de negócios criado."
  value       = aws_datazone_glossary.main.id
}

output "lambda_arn" {
  description = "ARN da Lambda que cria os assets"
  value       = aws_lambda_function.assets.arn
}
