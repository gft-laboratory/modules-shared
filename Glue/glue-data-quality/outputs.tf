output "ruleset_name" {
  description = "Nome do Data Quality Ruleset"
  value       = aws_glue_data_quality_ruleset.this.name
}

output "ruleset_arn" {
  description = "ARN do Data Quality Ruleset"
  value       = aws_glue_data_quality_ruleset.this.arn
}
