variable "topics" {
  description = "Lista de tópicos SNS a serem criados. Cada tópico deve conter nome obrigatório e outras configurações opcionais."
  type = list(object({
    name                      = string
    display_name              = optional(string)
    delivery_policy           = optional(string)
    fifo_topic                = optional(bool, false)
    content_based_deduplication = optional(bool, false)
    kms_master_key_id         = optional(string)
  }))
  default = []
}

variable "topic_policies" {
  description = "Mapa (chave: nome do tópico) com política JSON em string para aplicar no tópico SNS."
  type        = map(string)
  default     = {}
}

variable "subscriptions" {
  description = <<EOT
Lista de subscrições aos tópicos SNS. Cada subscrição deve conter:
- topic_name (string): nome do tópico ao qual subscreve
- protocol (string): protocolo da subscrição (e.g., email, sqs, lambda, http, https, sms)
- endpoint (string): destino da subscrição (e.g., email address, URL, ARN Lambda, ARN SQS)
- raw_message_delivery (bool, opcional)
- filter_policy (string JSON, opcional)
- redrive_policy (string JSON para DLQ, opcional)
- confirmation_timeout_in_minutes (number, opcional)
EOT
  type = list(object({
    topic_name                     = string
    protocol                       = string
    endpoint                       = string
    raw_message_delivery           = optional(bool, false)
    filter_policy                  = optional(string)
    redrive_policy                 = optional(string)
    confirmation_timeout_in_minutes = optional(number)
  }))
  default = []
}

variable "tags" {
  description = "Tags a serem aplicadas em todos os tópicos SNS."
  type        = map(string)
  default     = {}
}
