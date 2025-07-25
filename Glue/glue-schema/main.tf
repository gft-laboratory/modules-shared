locals {
  enabled = var.enabled
}

resource "aws_glue_schema" "this" {
  count = local.enabled ? 1 : 0

  schema_name       = var.schema_name != null ? var.schema_name : "glue-schema-default"
  description       = var.schema_description
  registry_arn      = var.registry_arn
  data_format       = var.data_format
  compatibility     = var.compatibility
  schema_definition = var.schema_definition

  tags = var.tags
}
