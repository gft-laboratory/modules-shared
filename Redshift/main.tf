#####################################
# Locals
#####################################
locals {
  # Mescla tags globais com tags específicas de cada recurso (se existirem)
  tags = merge(
    var.tags,
    {
      ManagedBy   = coalesce(var.managed_by, "terraform")
      Module      = "redshift-smart"
      Environment = var.environment
      Project     = var.project
    }
  )
}


#####################################
# Subnet Group (Provisioned)
#####################################
resource "aws_redshift_subnet_group" "this" {
  count       = var.mode == "provisioned" && var.create_subnet_group ? 1 : 0
  name        = var.subnet_group_name
  description = "Redshift Subnet Group (${var.environment})"
  subnet_ids  = var.subnet_ids
  tags        = local.tags
}

#####################################
# Parameter Group (Provisioned)
#####################################
resource "aws_redshift_parameter_group" "this" {
  count = var.mode == "provisioned" && var.create_parameter_group ? 1 : 0
  name  = var.parameter_group_name
  family = var.parameter_group_family
  tags   = local.tags

  dynamic "parameter" {
    for_each = var.parameter_overrides
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}

#####################################
# Redshift Cluster - Provisioned
#####################################
resource "aws_redshift_cluster" "this" {
  count = var.mode == "provisioned" ? 1 : 0

  cluster_identifier                  = var.cluster_identifier
  node_type                           = var.node_type
  number_of_nodes                     = var.number_of_nodes
  database_name                       = var.database_name
  master_username                     = var.master_username
  master_password                     = var.master_password
  port                                = var.port
  publicly_accessible                 = var.publicly_accessible
  enhanced_vpc_routing                = var.enhanced_vpc_routing
  allow_version_upgrade               = var.allow_version_upgrade
  automated_snapshot_retention_period = var.automated_snapshot_retention_period
  kms_key_id                          = var.kms_key_id
  encrypted                           = var.encrypted
  preferred_maintenance_window        = var.preferred_maintenance_window

  # VPC
  cluster_subnet_group_name = try(aws_redshift_subnet_group.this[0].name, var.existing_subnet_group_name)
  vpc_security_group_ids    = var.vpc_security_group_ids

  # Parameter Group
  cluster_parameter_group_name = try(aws_redshift_parameter_group.this[0].name, var.existing_parameter_group_name)

  # IAM Roles (Spectrum, COPY/UNLOAD, etc)
  iam_roles = var.iam_role_arns

  # Logging (configurado via recurso separado)
  depends_on = [
    aws_redshift_subnet_group.this,
    aws_redshift_parameter_group.this
  ]

  tags = local.tags

  lifecycle {
    ignore_changes = [
      master_password
    ]
  }
}

# Logging do cluster Provisioned
resource "aws_redshift_logging" "this" {
  count            = var.mode == "provisioned" && var.enable_logging ? 1 : 0
  cluster_identifier = aws_redshift_cluster.this[0].id
  bucket_name        = var.logging_bucket
  s3_key_prefix      = var.logging_s3_key_prefix
}

#####################################
# Redshift Serverless - Namespace
#####################################
resource "aws_redshiftserverless_namespace" "this" {
  count = var.mode == "serverless" ? 1 : 0

  namespace_name        = var.namespace_name
  admin_username        = var.admin_username
  admin_user_password   = var.admin_user_password
  db_name               = var.database_name
  default_iam_role_arn  = var.default_iam_role_arn
  iam_roles             = var.iam_role_arns
  kms_key_id            = var.kms_key_id
  log_exports           = var.serverless_log_exports
  tags                  = local.tags

  lifecycle {
    ignore_changes = [
      admin_user_password
    ]
  }
}

#####################################
# Redshift Serverless - Workgroup
#####################################
resource "aws_redshiftserverless_workgroup" "this" {
  count = var.mode == "serverless" ? 1 : 0

  workgroup_name       = var.workgroup_name
  namespace_name       = aws_redshiftserverless_namespace.this[0].namespace_name
  base_capacity        = var.base_capacity
  enhanced_vpc_routing = var.enhanced_vpc_routing
  publicly_accessible  = var.publicly_accessible
  port                 = var.port
  security_group_ids   = var.vpc_security_group_ids
  subnet_ids           = var.subnet_ids

  dynamic "config_parameter" {
    for_each = var.serverless_config_parameters
    content {
      parameter_key   = config_parameter.value.parameter_key
      parameter_value = config_parameter.value.parameter_value
    }
  }

  tags = local.tags
}