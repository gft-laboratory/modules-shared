resource "aws_sns_topic" "this" {
  for_each = { for t in var.topics : t.name => t }

  name                      = each.value.name
  display_name              = lookup(each.value, "display_name", null)
  delivery_policy           = lookup(each.value, "delivery_policy", null)
  fifo_topic                = lookup(each.value, "fifo_topic", false)
  content_based_deduplication = lookup(each.value, "content_based_deduplication", false)
  kms_master_key_id         = lookup(each.value, "kms_master_key_id", null)
  tags                      = var.tags
}

resource "aws_sns_topic_policy" "this" {
  for_each = aws_sns_topic.this

  arn    = each.value.arn
  policy = lookup(var.topic_policies, each.key, null)
}

resource "aws_sns_topic_subscription" "this" {
  for_each = { for s in var.subscriptions : "${s.topic_name}-${s.endpoint}" => s }

  topic_arn              = aws_sns_topic.this[each.value.topic_name].arn
  protocol               = each.value.protocol
  endpoint               = each.value.endpoint
  raw_message_delivery   = lookup(each.value, "raw_message_delivery", false)
  filter_policy          = lookup(each.value, "filter_policy", null)
  redrive_policy         = lookup(each.value, "redrive_policy", null)
  confirmation_timeout_in_minutes = lookup(each.value, "confirmation_timeout_in_minutes", null)
}