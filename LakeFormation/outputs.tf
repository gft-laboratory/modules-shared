output "lakeformation_admins" {
  description = "Lista de administradores configurados no Lake Formation."
  value       = aws_lakeformation_data_lake_settings.this.admins
}

output "lf_tags" {
  description = "Tags do Lake Formation criadas."
  value       = aws_lakeformation_lf_tag.tags
}

output "lf_tags_assignment" {
  description = "Associações de LF-Tags aos recursos."
  value       = aws_lakeformation_resource_lf_tags.tags_assignment
}

output "databases_permissions" {
  description = "Permissões aplicadas a bancos de dados."
  value       = aws_lakeformation_permissions.databases
}

output "tables_permissions" {
  description = "Permissões aplicadas a tabelas."
  value       = aws_lakeformation_permissions.tables
}
