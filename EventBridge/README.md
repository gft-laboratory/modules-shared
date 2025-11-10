# Módulo EventBridge - AWS

Este módulo gerencia a criação de recursos do **Amazon EventBridge**, incluindo:

- Event Bus customizado (ou uso de um existente)
- Regras com agendamento (`schedule_expression`) ou padrão de eventos (`event_pattern`)
- Destinos (targets) para invocação de serviços (Lambda, SNS, SQS, Step Functions, etc.)

## Recursos suportados

- `aws_cloudwatch_event_bus`
- `aws_cloudwatch_event_rule`
- `aws_cloudwatch_event_target`

---

## Como usar

```hcl
module "eventbridge" {
  source = "git::ssh://git@github.com/SEU_ORG/SEU_REPO.git//modules/EventBridge?ref=v0.1.0"

  create_event_bus = true
  event_bus_name   = "meu-event-bus"

  event_rules = [
    {
      name          = "regra-agendada"
      description   = "Dispara toda noite"
      schedule_expression = "cron(0 0 * * ? *)"
    },
    {
      name          = "regra-evento-s3"
      description   = "Dispara com evento S3"
      event_pattern = jsonencode({
        "source": ["aws.s3"],
        "detail-type": ["Object Created"]
      })
    }
  ]

  event_targets = [
    {
      rule_name  = "regra-agendada"
      target_id  = "lambda1"
      arn        = "arn:aws:lambda:us-east-1:111122223333:function:minha-funcao"
    }
  ]

  tags = {
    Projeto = "DataLake"
    Ambiente = "Desenvolvimento"
  }
}
```

# Variáveis
| Nome               | Descrição                                            | Tipo     | Obrigatório | Default |
| ------------------ | ---------------------------------------------------- | -------- | ----------- | ------- |
| `create_event_bus` | Se verdadeiro, cria um Event Bus novo                | `bool`   | Não         | `true`  |
| `event_bus_name`   | Nome do Event Bus                                    | `string` | Sim         |         |
| `event_rules`      | Lista de regras com padrão de eventos ou agendamento | `list`   | Não         | `[]`    |
| `event_targets`    | Lista de destinos para as regras                     | `list`   | Não         | `[]`    |
| `tags`             | Mapa de tags a serem aplicadas aos recursos          | `map`    | Não         | `{}`    |

# Outputs
| Nome             | Descrição                   |
| ---------------- | --------------------------- |
| `event_bus_arn`  | ARN do Event Bus criado     |
| `event_bus_name` | Nome do Event Bus usado     |
| `rules`          | Mapa de regras criadas      |
| `targets`        | Mapa de destinos das regras |

# Requisitos
* Terraform >= 1.3
* Provider AWS >= 5.0