# Módulo Terraform AWS DataZone (Ultra Completo)

Este módulo cria recursos AWS DataZone de forma **inteligente e totalmente parametrizável**.

Recursos suportados:

- Domain
- Project
- Assets (com metadata, owner e tags customizadas)
- Permissões de Assets (opcional)

## Variáveis

| Nome | Tipo | Descrição | Default |
|------|------|-----------|---------|
| region | string | Região AWS | us-east-1 |
| tags | map(string) | Tags aplicadas a todos os recursos | {} |
| create_domain | bool | Criar Domain | true |
| domain_name | string | Nome do Domain | example-domain |
| domain_description | string | Descrição do Domain | "Domain criado via Terraform" |
| create_project | bool | Criar Project | true |
| project_name | string | Nome do Project | example-project |
| project_description | string | Descrição do Project | "Project criado via Terraform" |
| project_owner | string | Owner do Project | owner@example.com |
| create_assets | bool | Criar Assets | false |
| assets | list(object) | Lista de assets com `name`, `type`, `description`, `owner`, `metadata` e `tags` | [] |
| create_asset_permissions | bool | Criar permissões para Assets | false |
| asset_permissions | list(object) | Lista de permissões com `principal` e `actions` | [] |

## Outputs

- **domain**: informações completas do Domain
- **project**: informações completas do Project
- **assets**: lista detalhada de Assets
- **asset_permissions**: lista de permissões aplicadas aos Assets

## Exemplo de Consumo

```hcl
module "datazone" {
  source = "git::ssh://git@github.com/SEU_ORG/SEU_REPO.git//modules/DataZone?ref=v2.0.0"

  region = "us-east-1"
  tags   = { env = "dev", team = "data" }

  create_domain       = true
  domain_name         = "my-domain"
  domain_description  = "Domain principal"

  create_project      = true
  project_name        = "my-project"
  project_description = "Projeto principal"
  project_owner       = "owner@example.com"

  create_assets       = true
  assets = [
    {
      name        = "sales-data"
      type        = "dataset"
      description = "Dados de vendas"
      owner       = "owner@example.com"
      metadata    = { source = "s3://bucket-vendas" }
      tags        = { sensitivity = "low" }
    }
  ]

  create_asset_permissions = true
  asset_permissions = [
    { principal = "arn:aws:iam::123456789012:user/alice", actions = ["READ", "WRITE"] }
  ]
}
```

## Módulo DataZone Assets

Este módulo cria **Assets no Amazon DataZone** usando um `Custom Resource` via Lambda,
já que atualmente o recurso `Asset` não está disponível em CloudFormation/Terraform.

### Exemplo de uso

```hcl
module "datazone_assets" {
  source     = "./modules/datazone-assets"
  name_prefix = "demo"
  domain_id  = module.datazone.domain_id
  project_id = module.datazone.project_id

  assets = [
    {
      name        = "sales-data"
      type        = "S3_OBJECT"
      description = "Dados de vendas no S3"
    }
  ]
}
```
