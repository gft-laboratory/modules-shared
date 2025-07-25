# Glue Data Quality Module

Este módulo cria um recurso `aws_glue_data_quality_ruleset` com a opção de executar uma `evaluation_run`.

## Requisitos

- Terraform 1.3+
- AWS Provider 4.0+

## Variáveis

| Nome                  | Descrição                                           | Obrigatório |
|-----------------------|-----------------------------------------------------|-------------|
| name                  | Nome do Ruleset                                     | Sim         |
| description           | Descrição do Ruleset                                | Não         |
| ruleset               | Regras em DQDL (Data Quality Definition Language)   | Sim         |
| database_name         | Nome do banco de dados Glue                         | Sim         |
| table_name            | Nome da tabela Glue                                 | Sim         |
| tags                  | Tags AWS                                            | Não         |
| enable_evaluation_run | Executar avaliação após criação?                    | Não         |

## Outputs

- `ruleset_name`: Nome do ruleset criado
- `ruleset_arn`: ARN do ruleset

## Exemplo de Uso

```hcl
module "glue_data_quality" {
  source = "../modules/Glue/glue-data-quality\"

  name        = "dq-ruleset-payments\"
  description = "Validação dos dados da tabela payments\"
  ruleset     = file(\"./rulesets/payment_rules.dqdl\")
  database_name = module.glue_catalog_database.name
  table_name    = module.glue_catalog_table.name
  tags = {
    Environment = "dev\"
    Owner       = "data-team\"
  }
  enable_evaluation_run = true
}
```