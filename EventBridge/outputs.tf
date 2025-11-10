output "event_bus_arn" {
  value       = var.create_event_bus ? aws_cloudwatch_event_bus.this[0].arn : null
  description = "ARN do Event Bus criado (se aplicável)."
}

output "event_bus_name" {
  value       = var.create_event_bus ? aws_cloudwatch_event_bus.this[0].name : var.event_bus_name
  description = "Nome do Event Bus criado ou utilizado."
}

output "rules" {
  value       = { for k, v in aws_cloudwatch_event_rule.this : k => {
    arn         = v.arn
    name        = v.name
    description = v.description
  } }
  description = "Mapeamento das regras criadas, com ARN, nome e descrição."
}

output "targets" {
  value       = { for k, v in aws_cloudwatch_event_target.this : k => {
    rule      = v.rule
    target_id = v.target_id
    arn       = v.arn
  } }
  description = "Mapeamento dos destinos configurados nas regras."
}
