locals {
  enabled = var.enabled
}

resource "aws_glue_workflow" "this" {
  count = local.enabled ? 1 : 0

  name                   = var.workflow_name != null ? var.workflow_name : "${var.workflow_prefix != null ? var.workflow_prefix : "glue-workflow"}"
  description            = var.workflow_description
  default_run_properties = var.default_run_properties
  max_concurrent_runs    = var.max_concurrent_runs

  tags = var.tags
}
