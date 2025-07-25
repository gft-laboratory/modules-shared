locals {
  enabled = var.enabled
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_connection
resource "aws_glue_connection" "this" {
  count = local.enabled ? 1 : 0

  name                  = var.connection_name != null ? var.connection_name : "${var.name_prefix != null ? var.name_prefix : "glue-connection"}"
  description           = var.connection_description
  catalog_id            = var.catalog_id
  connection_type       = var.connection_type
  connection_properties = var.connection_properties
  match_criteria        = var.match_criteria

  dynamic "physical_connection_requirements" {
    for_each = var.physical_connection_requirements != null ? [true] : []

    content {
      availability_zone      = var.physical_connection_requirements.availability_zone
      security_group_id_list = var.physical_connection_requirements.security_group_id_list
      subnet_id              = var.physical_connection_requirements.subnet_id
    }
  }

  tags = var.tags
}
