locals {
  enabled = var.enabled
}

resource "aws_glue_registry" "this" {
  count = local.enabled ? 1 : 0

  registry_name = var.registry_name != null ? var.registry_name : "glue-registry-default"
  description   = var.registry_description

  tags = var.tags
}
