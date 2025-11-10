# Terraform Module — AWS Step Function

## ✨ Objetivo

Este módulo provisiona uma **AWS Step Function** (State Machine), podendo ser do tipo `STANDARD` ou `EXPRESS`, com suporte a logging, IAM role e definição flexível do fluxo via Amazon States Language (JSON).

---

## 📦 Recursos Criados

- `aws_iam_role` — Role para a Step Function executar serviços AWS.
- `aws_iam_role_policy` — Policy customizada fornecida via input.
- `aws_sfn_state_machine` — A máquina de estado em si.

---

## 📥 Variáveis

| Nome                      | Descrição                                                        | Tipo         | Obrigatório | Default    |
|---------------------------|------------------------------------------------------------------|--------------|-------------|------------|
| `name`                    | Nome da Step Function                                            | `string`     | Sim         | —          |
| `role_name`               | Nome da Role IAM                                                 | `string`     | Sim         | —          |
| `role_policy_json`        | JSON com as permissões necessárias (ex: invocar lambdas)         | `string`     | Sim         | —          |
| `definition`              | Definição da Step Function em Amazon States Language (JSON)      | `string`     | Sim         | —          |
| `state_machine_type`      | Tipo da State Machine (`STANDARD` ou `EXPRESS`)                  | `string`     | Não         | `STANDARD` |
| `logging_level`           | Nível de log (`ALL`, `ERROR`, `FATAL`, `OFF`)                    | `string`     | Não         | `OFF`      |
| `include_execution_data`  | Incluir dados de execução no log                                 | `bool`       | Não         | `false`    |
| `cloudwatch_log_group_arn`| ARN do Log Group (se desejar ativar logs)                        | `string`     | Não         | `null`     |
| `tags`                    | Tags para os recursos                                            | `map(string)`| Não         | `{}`       |

---

## 📤 Outputs

| Nome                        | Descrição                                  |
|-----------------------------|--------------------------------------------|
| `step_function_arn`         | ARN da máquina de estado                   |
| `step_function_name`        | Nome da máquina de estado                  |
| `step_function_role_arn`    | ARN da IAM Role usada                      |
| `step_function_logging_level` | Nível de log configurado                  |

---

## 🧠 Exemplos de Uso

```hcl
module "step_function" {
  source = "./modules/step_function"

  name               = "etl-orchestrator"
  role_name          = "role-etl-orchestrator"
  role_policy_json   = file("${path.module}/iam/step_policy.json")
  definition         = file("${path.module}/definitions/etl_state_machine.json")
  state_machine_type = "STANDARD"

  logging_level            = "ERROR"
  include_execution_data   = true
  cloudwatch_log_group_arn = "arn:aws:logs:us-east-1:123456789012:log-group:/aws/vendedloggroup/etl"

  tags = {
    Environment = "dev"
    Project     = "DataLake"
  }
}
```

# 📚 Referências
* [AWS Step Functions Docs](https://docs.aws.amazon.com/step-functions/latest/dg/welcome.html)
* [Amazon States Language Specification](https://states-language.net/spec.html)


# 🛡️ Requisitos
* Terraform ≥ 1.0
* AWS Provider ≥ 4.0