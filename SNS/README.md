# Módulo Terraform SNS - AWS

Este módulo cria tópicos SNS e suas subscrições com flexibilidade e funcionalidades robustas.

## Recursos criados

- **Tópicos SNS**
  - Nome
  - Display name
  - Suporte a FIFO e deduplicação
  - KMS para criptografia do tópico
  - Delivery Policy customizada
  - Tags

- **Políticas SNS**
  - Política JSON customizada para controlar permissões

- **Subscrições SNS**
  - Protocolos suportados: `email`, `sms`, `lambda`, `sqs`, `http`, `https`
  - Filter Policy para filtrar mensagens recebidas
  - Raw Message Delivery para receber a mensagem bruta
  - Redrive Policy para Dead Letter Queue via SQS
  - Configuração de timeout para confirmação da subscrição

## Como usar

### Exemplo de configuração `variables.tf`

```hcl
topics = [
  {
    name         = "my-topic"
    display_name = "My Topic"
    fifo_topic   = false
  }
]

topic_policies = {
  "my-topic" = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "SNS:Publish"
        Resource = "*"
      }
    ]
  })
}

subscriptions = [
  {
    topic_name = "my-topic"
    protocol   = "email"
    endpoint   = "meuemail@example.com"
    raw_message_delivery = true
  }
]
```

# Outputs
* topics: Mapa de tópicos criados com seus ARNs e nomes.
* subscriptions: Lista com detalhes das subscrições criadas.

# Requisitos
* Terraform 1.0+
* Provider AWS configurado com credenciais