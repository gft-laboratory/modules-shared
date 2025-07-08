# 🔐 Módulo Terraform - Secrets Manager

Este módulo cria um segredo no AWS Secrets Manager com uma versão inicial e opção de criptografia via KMS.

---

## 🚀 Exemplo de Uso

```hcl
module "secrets_manager" {
  source        = "./modules/SecretsManager"
  secret_name   = "meu-segredo-api"
  description   = "Segredo da API do sistema X"
  secret_value  = jsonencode({ username = "admin", password = "1234" })
  tags          = { Environment = "dev", Team = "plataforma" }
}
```

---

## 📥 Variáveis de Entrada

| Variável       | Tipo          | Obrigatória | Descrição                                                   |
|----------------|---------------|-------------|-------------------------------------------------------------|
| `secret_name`  | `string`      | ✅ Sim      | Nome do segredo a ser criado                                |
| `description`  | `string`      | ❌ Não      | Descrição do segredo                                        |
| `kms_key_id`   | `string`      | ❌ Não      | ID da KMS Key usada para criptografia (opcional)            |
| `secret_value` | `string`      | ✅ Sim      | Valor do segredo (pode ser string simples ou JSON)          |
| `tags`         | `map(string)` | ❌ Não      | Tags aplicadas ao recurso                                   |

---

## 📤 Outputs

| Output        | Descrição                          |
|---------------|-------------------------------------|
| `secret_id`   | ID do segredo criado                |
| `secret_arn`  | ARN do segredo                      |
| `secret_name` | Nome do segredo                     |

