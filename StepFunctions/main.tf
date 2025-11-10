resource "aws_sfn_state_machine" "this" {
  name     = var.name
  role_arn = var.role_arn

  definition = var.definition
  type       = var.state_machine_type

  dynamic "logging_configuration" {
    for_each = var.cloudwatch_log_group_arn != null ? [1] : []

    content {
      level                  = var.logging_level
      include_execution_data = var.include_execution_data
      log_destination        = var.cloudwatch_log_group_arn
    }
  }

  tracing_configuration {
    enabled = var.enable_tracing
  }

  tags = var.tags
}
