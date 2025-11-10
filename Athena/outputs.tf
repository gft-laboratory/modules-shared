###################################
# Outputs - Athena Module
###################################

output "athena_workgroups" {
  description = "Informações dos WorkGroups criados"
  value       = aws_athena_workgroup.this
}

output "athena_named_queries" {
  description = "Informações das Named Queries criadas"
  value       = aws_athena_named_query.this
}

output "athena_data_catalogs" {
  description = "Data Catalogs adicionais criados"
  value       = aws_athena_data_catalog.this
}
