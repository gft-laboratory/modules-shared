#####################################
# Subnet Group (Provisioned)
#####################################
output "subnet_group_name" {
  description = "Nome do Redshift Subnet Group (se criado)."
  value       = try(aws_redshift_subnet_group.this[0].name, null)
}

output "subnet_group_arn" {
  description = "ARN do Redshift Subnet Group (se suportado)."
  value       = try(aws_redshift_subnet_group.this[0].arn, null)
}

#####################################
# Parameter Group (Provisioned)
#####################################
output "parameter_group_name" {
  description = "Nome do Redshift Parameter Group (se criado)."
  value       = try(aws_redshift_parameter_group.this[0].name, null)
}

output "parameter_group_arn" {
  description = "ARN do Redshift Parameter Group (se suportado)."
  value       = try(aws_redshift_parameter_group.this[0].arn, null)
}

#####################################
# Cluster (Provisioned)
#####################################
output "cluster_name" {
  description = "Identificador (nome) do Cluster Redshift (provisioned)."
  value       = try(aws_redshift_cluster.this[0].cluster_identifier, null)
}

output "cluster_arn" {
  description = "ARN do Cluster Redshift (provisioned)."
  value       = try(aws_redshift_cluster.this[0].arn, null)
}

#####################################
# Serverless - Namespace
#####################################
output "namespace_name" {
  description = "Nome do Namespace do Redshift Serverless."
  value       = try(aws_redshiftserverless_namespace.this[0].namespace_name, null)
}

output "namespace_arn" {
  description = "ARN do Namespace do Redshift Serverless."
  value       = try(aws_redshiftserverless_namespace.this[0].arn, null)
}

#####################################
# Serverless - Workgroup
#####################################
output "workgroup_name" {
  description = "Nome do Workgroup do Redshift Serverless."
  value       = try(aws_redshiftserverless_workgroup.this[0].workgroup_name, null)
}

output "workgroup_arn" {
  description = "ARN do Workgroup do Redshift Serverless."
  value       = try(aws_redshiftserverless_workgroup.this[0].arn, null)
}
