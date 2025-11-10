resource "aws_cloudwatch_event_bus" "this" {
  count = var.create_event_bus ? 1 : 0

  name = var.event_bus_name
  lifecycle {
    create_before_destroy = true
  }
  tags = var.tags
}

resource "aws_cloudwatch_event_rule" "this" {
  for_each = { for r in var.event_rules : r.name => r }

  name               = each.value.name
  description        = each.value.description
  event_bus_name     = var.create_event_bus ? aws_cloudwatch_event_bus.this[0].name : var.event_bus_name
  event_pattern      = each.value.event_pattern
  schedule_expression = each.value.schedule_expression
  role_arn           = each.value.role_arn
  state = each.value.is_enabled ? "ENABLED" : "DISABLED"
  tags               = var.tags
}

resource "aws_cloudwatch_event_target" "this" {
  for_each = {
    for r in var.event_targets : "${r.rule_name}-${r.target_id}" => r
  }

  rule      = aws_cloudwatch_event_rule.this[each.value.rule_name].name
  target_id = each.value.target_id
  arn       = each.value.arn
  input     = each.value.input
  role_arn  = each.value.role_arn
  event_bus_name = var.create_event_bus ? aws_cloudwatch_event_bus.this[0].name : var.event_bus_name
}

# Lança erro se houver schedule_expression com Event Bus customizado
resource "null_resource" "validate_schedule_expression_usage" {
  count = var.create_event_bus && anytrue([
    for rule in var.event_rules : (
      try(rule.schedule_expression != null && rule.schedule_expression != "", false)
    )
  ]) ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'Erro: schedule_expression só pode ser usado no Event Bus padrão. Use create_event_bus = false e event_bus_name = \"default\" para regras com cron ou rate.' && exit 1"
  }
}