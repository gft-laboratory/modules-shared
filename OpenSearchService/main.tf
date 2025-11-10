resource "aws_opensearch_domain" "this" {
  domain_name = var.domain_name

  engine_version = var.engine_version

  cluster_config {
    instance_type            = var.instance_type
    instance_count           = var.instance_count
    zone_awareness_enabled   = var.zone_awareness_enabled
    zone_awareness_config {
      availability_zone_count = var.zone_awareness_enabled ? var.availability_zone_count : null
    }
    dedicated_master_enabled = var.dedicated_master_enabled
    dedicated_master_type    = var.dedicated_master_enabled ? var.dedicated_master_type : null
    dedicated_master_count   = var.dedicated_master_enabled ? var.dedicated_master_count : null
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.ebs_volume_size
    volume_type = var.ebs_volume_type
    iops        = var.ebs_volume_type == "io1" ? var.ebs_iops : null
  }

  encrypt_at_rest {
    enabled    = var.encrypt_at_rest_enabled
    kms_key_id = var.kms_key_id
  }

  node_to_node_encryption {
    enabled = var.node_to_node_encryption_enabled
  }

  domain_endpoint_options {
    enforce_https                   = true
    tls_security_policy              = var.tls_security_policy
    custom_endpoint_enabled          = var.custom_endpoint_enabled
    custom_endpoint                  = var.custom_endpoint_enabled ? var.custom_endpoint : null
    custom_endpoint_certificate_arn  = var.custom_endpoint_enabled ? var.custom_endpoint_certificate_arn : null
  }

  vpc_options {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  access_policies = var.access_policies

  advanced_options = var.advanced_options

  dynamic "snapshot_options" {
    for_each = var.snapshot_start_hour != null ? [1] : []
    content {
      automated_snapshot_start_hour = var.snapshot_start_hour
    }
  }

  dynamic "log_publishing_options" {
    for_each = var.cloudwatch_log_group_arn != null ? [1] : []
    content {
      cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch_audit[0].arn
      log_type                 = "INDEX_SLOW_LOGS"
      enabled                  = true
    }
  }

  tags = var.tags
}

# Opcional: registro no CloudWatch para auditoria adicional
resource "aws_cloudwatch_log_group" "opensearch_audit" {
  count = var.log_retention_days != null ? 1 : 0

  name              = "/aws/opensearch/${var.domain_name}/audit"
  retention_in_days = var.log_retention_days
  tags              = var.tags
}
