
# Terraform AWS DynamoDB Module

Este módulo Terraform cria uma tabela DynamoDB na AWS com suporte a:

- Chave de partição (obrigatória)
- Chave de ordenação (opcional)
- Point-in-Time Recovery (PITR)
- Encriptação com KMS (opcional)
- DynamoDB Streams (opcional)
- Integração com Kinesis Streams (opcional)

---

## Pré-requisitos

- Terraform >= 1.0
- Provedor AWS configurado com credenciais adequadas

---

## Uso

### Exemplo básico com chave de partição e sort key

```hcl
module "dynamodb" {
  source = "git::ssh://git@github.com/SEU_ORG/SEU_REPO.git//modules/DynamoDB?ref=v0.5.3"

  table_name          = "ProcessExecutionControl"
  partition_key_name  = "table"
  partition_key_type  = "S"

  sort_key_name       = "partition_date"
  sort_key_type       = "S"

  point_in_time_recovery_enabled = false

  stream_enabled      = true
  stream_view_type    = "KEYS_ONLY"

  kinesis_stream_name = "ProcessExecutionControl-kinesis-stream"

  kms_key_arn         = null  # Usar SSE padrão da AWS

  tags_dynamodb = {
    Terraform   = "true"
    Project     = "NAD"
    Environment = "dev"
  }
}
```

---

## Variáveis de entrada

| Nome                      | Tipo            | Padrão               | Obrigatório | Descrição                                                                                 |
|---------------------------|-----------------|---------------------|-------------|-------------------------------------------------------------------------------------------|
| `table_name`              | string          | —                   | sim         | Nome da tabela DynamoDB                                                                  |
| `partition_key_name`      | string          | —                   | sim         | Nome da chave de partição                                                                |
| `partition_key_type`      | string          | —                   | sim         | Tipo da chave de partição (`S`, `N` ou `B`)                                              |
| `sort_key_name`           | string          | `null`              | não         | Nome da chave de ordenação (opcional)                                                    |
| `sort_key_type`           | string          | `null`              | não         | Tipo da chave de ordenação (`S`, `N` ou `B`)                                            |
| `point_in_time_recovery_enabled` | bool    | `true`              | não         | Habilita Point-in-Time Recovery (PITR)                                                  |
| `stream_enabled`          | bool            | `false`             | não         | Habilita DynamoDB Streams                                                                |
| `stream_view_type`        | string          | `null`              | não         | Tipo de dados da stream. Válidos: `KEYS_ONLY`, `NEW_IMAGE`, `OLD_IMAGE`, `NEW_AND_OLD_IMAGES` |
| `kinesis_stream_name`     | string          | `null`              | não         | Nome do stream Kinesis (criado se `stream_enabled = true`)                               |
| `kinesis_shard_count`     | number          | `1`                 | não         | Quantidade de shards do stream Kinesis                                                  |
| `kinesis_retention_period`| number          | `24`                | não         | Retenção dos dados no stream Kinesis (em horas)                                         |
| `kms_key_arn`             | string          | `null`              | não         | ARN da chave KMS para encriptação. `null` usa SSE padrão da AWS                          |
| `encryption_type`         | string          | `"KMS"`             | não         | Tipo de encriptação para Kinesis. Valores válidos: `KMS`, `NONE`                         |
| `tags_dynamodb`           | map(string)     | `{terraform=true, backup=dynamodb}` | não | Tags a aplicar na tabela DynamoDB                                                       |
| `environment`             | string          | `"dev"`             | não         | Ambiente (dev, prod, etc.)                                                                |

---

## Outputs

| Nome                       | Descrição                         |
|----------------------------|----------------------------------|
| `dynamodb_table_arn`       | ARN da tabela DynamoDB            |
| `dynamodb_table_name`      | Nome da tabela DynamoDB           |
| `dynamodb_table_stream_arn`| ARN do stream DynamoDB (se ativado) |

---

## Notas

- Quando `stream_enabled` for `true`, é obrigatório definir `stream_view_type`. O módulo irá validar essa condição em tempo de execução.
- Caso `kinesis_stream_name` não seja informado, o módulo cria um nome padrão baseado no nome da tabela (`<table_name>-stream`).
- Se `kms_key_arn` não for fornecido, será usada a encriptação padrão da AWS para DynamoDB.
