output "topics" {
  description = "Mapa de tópicos SNS criados (nome -> arn)."
  value = { for k, v in aws_sns_topic.this : k => {
    arn          = v.arn
    name         = v.name
    display_name = v.display_name
  }}
}

output "subscriptions" {
  description = "Lista das subscrições SNS criadas com seus IDs."
  value = [for s in aws_sns_topic_subscription.this : {
    id          = s.id
    topic_arn   = s.topic_arn
    protocol    = s.protocol
    endpoint    = s.endpoint
    raw_message_delivery = s.raw_message_delivery
  }]
}
