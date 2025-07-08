## 🔐 KMS Module

Este README documenta os recursos utilizados na configuração do Terraform para AWS KMS, incluindo descrições, tipos, valores padrão e instruções de uso.

---

## 📌 How to Use

### ✅ Pre-requisitos

- [Terraform](https://www.terraform.io/downloads.html) instalado.
- Credenciais da AWS configuradas.

### 🚀 Exemplo de Uso

```hcl
module "kms" {
  source = "./KMS"

  alias                   = var.kms_alias
  description             = "Key used for encryption in Data Lake"
  enable_key_rotation     = true
  is_enabled              = true
  deletion_window_in_days = 7
  tags = {
    Environment = var.environment
    Module      = "module-kms"
  }
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |


## 🧩 Inputs

| Name                          | Description                                                             | Type         | Default                                | Required |
|-------------------------------|-------------------------------------------------------------------------|--------------|----------------------------------------|:--------:|
| `alias`                       | Nome do alias da chave KMS. Será prefixado com `alias/` automaticamente. | `string`     | n/a                                    | ✅       |
| `description`                 | Descrição da chave KMS.                                                 | `string`     | `"KMS key managed by Terraform"`       | ❌       |
| `enable_key_rotation`         | Habilita a rotação automática da chave.                                | `bool`       | `true`                                 | ❌       |
| `is_enabled`                  | Define se a chave está habilitada.                                     | `bool`       | `true`                                 | ❌       |
| `deletion_window_in_days`     | Dias de espera para deletar a chave após destruição.                   | `number`     | `30`                                   | ❌       |
| `multi_region`                | Define se a chave é multi-região.                                      | `bool`       | `false`                                | ❌       |
| `kms_policy`                  | Política personalizada opcional em JSON para a chave.                  | `string`     | `null`                                 | ❌       |
| `tags`                        | Mapa de tags aplicadas à chave e ao alias.                             | `map(string)`| `{}`                                   | ❌       |


## 📤 Outputs

| Name         | Description                 |
|--------------|-----------------------------|
| `key_id`     | ID da chave KMS             |
| `key_arn`    | ARN da chave KMS            |
| `alias_name` | Nome do alias da chave KMS  |
