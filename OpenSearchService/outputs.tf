output "domain_arn" {
  description = "ARN do domínio OpenSearch criado"
  value       = aws_opensearch_domain.this.arn
}

output "domain_id" {
  description = "ID do domínio OpenSearch"
  value       = aws_opensearch_domain.this.domain_id
}

output "domain_endpoint" {
  description = "Endpoint público do domínio OpenSearch"
  value       = aws_opensearch_domain.this.endpoint
}

output "domain_dashboard_endpoint" {
  description = "Endpoint do painel do OpenSearch Dashboards"
  value       = aws_opensearch_domain.this.dashboard_endpoint
}

output "vpc_options" {
  description = "Configuração de VPC usada pelo domínio"
  value       = aws_opensearch_domain.this.vpc_options
}
