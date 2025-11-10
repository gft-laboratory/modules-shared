## Módulo: IAM-Role

Este módulo cria uma Role personalizada na AWS com suporte a `permissions_boundary`, tags e políticas gerenciadas.

---

### 📁 Estrutura de Arquivos

```
modules/
└── IAM-Role/
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md
```

### 💡 Exemplo de Uso

```hcl
module "lambda_iam_role" {
  source = "git::ssh://git@github.com/SEU_ORG/SEU_REPO.git//modules/IAM-Role?ref=v0.0.7"

  name          = local.lambda_role_name
  tags_iam_role = local.lambda_tags
}
```

Para atachar uma policy criada via módulo na role criada é só utilizar o campo role_attach_policy_managed_name.

```hcl
module "lambda_policies_sagemaker" {
  source = "git::ssh://git@github.com/SEU_ORG/SEU_REPO.git//modules/IAM-Policy?ref=v0.0.7"

  policy_name                      = "datalaker_custom_policy"
  policy_description               = "Custom policy to Sagemaker resources"
  policy_path                      = "/"
  policy_document                  = file("./json_policy/datalaker_policy.json")
  role_attach_policy_managed_name = module.lambda_iam_role.iam_role_name

  depends_on = [ module.lambda_iam_role ]
}
```


---

### ✅ Recursos Criados

- `aws_iam_role` com assume role configurado para um serviço (padrão: S3)
- `permissions_boundary` (opcional)
- `managed_policy_arns` (opcional)
- Saídas: `name`, `arn`, `unique_id`

---

### 📥 Variáveis de Entrada

| Variável                         | Tipo             | Obrigatória | Descrição                                                                 |
|----------------------------------|------------------|-------------|---------------------------------------------------------------------------|
| `name`                           | `string`         | ✅ Sim      | Nome base da Role (sufixo `-role` será adicionado automaticamente)       |
| `tags_iam_role`                  | `map(string)`    | ❌ Não      | Tags aplicadas à Role                                                    |
| `iam_role_permissions_boundary` | `string`         | ❌ Não      | ARN da policy usada como boundary de permissões                          |
| `managed_policy_arns`           | `list(string)`   | ❌ Não      | Lista de policies gerenciadas que serão anexadas à Role                  |
| `assume_role_policy`            | `string`         | ❌ Não      | Caminho para o arquivo JSON com a política de trust (assume role policy) |

---

### 📤 Outputs

| Output             | Descrição                             |
|--------------------|----------------------------------------|
| `iam_role_name`    | Nome da IAM Role criada                |
| `iam_role_arn`     | ARN da IAM Role criada                 |
| `iam_role_unique_id` | Unique ID da IAM Role                |

---
