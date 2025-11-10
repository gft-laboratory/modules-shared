# Módulo Terraform — Amazon Redshift (Provisioned e Serverless)

Este módulo provê a criação **flexível e segura** de recursos do **Amazon Redshift**, suportando dois modos distintos:

- **Provisioned (Cluster clássico)**: cria um **Cluster** gerenciado (com Subnet Group, Parameter Group e logging S3 opcionais).
- **Serverless**: cria um **Namespace** e um **Workgroup**, com suporte a VPC (subnets/SG), parâmetros e exportação de logs.

---

## 📌 Por que dois modos?

- **Serverless**: ideal para workloads elásticos, sob demanda, com menor sobrecarga operacional.  
- **Provisioned**: útil em ambientes legados, workloads previsíveis e cenários que exigem maior controle de versão e configuração.

> ⚠️ Importante:  
> O valor da variável `mode` determina quais variáveis são **obrigatórias**.  
> - Se `mode = "provisioned"`, você precisa fornecer `cluster_identifier`, `node_type`, `number_of_nodes`, etc.  
> - Se `mode = "serverless"`, você precisa fornecer `namespace_name`, `workgroup_name`, etc.  

---

## 📂 Estrutura do módulo

- `main.tf` → lógica principal e recursos AWS.  
- `variables.tf` → todas as variáveis com descrições em português.  
- `outputs.tf` → saídas padronizadas no formato **name** e **arn** (quando disponível).  
- `README.md` → este guia.  

---

## ✅ Boas práticas aplicadas

- **Tags consistentes**: `locals.tags` mescla `var.tags` com contexto (`Project`, `Environment`, `ManagedBy`).  
- **Segurança**:
  - Senhas são `sensitive` e marcadas para `ignore_changes` no lifecycle (suportando rotação).
  - `publicly_accessible = false` por padrão.
  - **Enhanced VPC Routing** habilitado por default.
  - Suporte a **KMS** (`kms_key_id`) para criptografia em ambos os modos.
- **Rede**:  
  - Suporte a SG existente (`vpc_security_group_ids`) ou criação de SG gerenciado (`create_security_group`).  
- **Parâmetros**:  
  - **Provisioned** → `aws_redshift_parameter_group` (overrides configuráveis).  
  - **Serverless** → `serverless_config_parameters`.  
- **Logging**:  
  - **Cluster** → `aws_redshift_logging` envia logs para S3.  
  - **Serverless** → `serverless_log_exports` exporta logs para CloudWatch/S3.  

---

## 📋 Requisitos

- Terraform `>= 1.5.0`
- AWS Provider `>= 5.0`
- Permissões IAM para: Redshift, VPC, SG, KMS, S3, CloudWatch Logs.

---

## 🔧 Variáveis principais

> Veja `variables.tf` para descrições detalhadas.

### Comuns
- `mode` → `"provisioned"` | `"serverless"`.
- `database_name`, `port`, `publicly_accessible`, `enhanced_vpc_routing`, `iam_role_arns`, `kms_key_id`, `encrypted`.
- `project`, `environment`, `tags`.

### Rede
- `vpc_id`, `subnet_ids`, `vpc_security_group_ids`.  
- `create_security_group` + `sg_ingress_rules` / `sg_egress_rules`.

### Provisioned (Cluster)
- `cluster_identifier`, `node_type`, `number_of_nodes`.  
- `master_username`, `master_password`.  
- Subnet/Parameter Group (`create_subnet_group`, `create_parameter_group`).  
- Logging → `enable_logging`, `logging_bucket`, `logging_s3_key_prefix`.

### Serverless
- `namespace_name`, `workgroup_name`.  
- `admin_username`, `admin_user_password`.  
- `base_capacity`, `serverless_config_parameters`.  
- `serverless_log_exports`.

---

## 📤 Saídas

Saídas seguem o padrão `name` e `arn`:

- SG → `security_group_name`, `security_group_arn`.  
- Subnet Group → `subnet_group_name`, `subnet_group_arn`.  
- Parameter Group → `parameter_group_name`, `parameter_group_arn`.  
- Cluster (provisioned) → `cluster_name`, `cluster_arn`.  
- Namespace (serverless) → `namespace_name`, `namespace_arn`.  
- Workgroup (serverless) → `workgroup_name`, `workgroup_arn`.  

---

## 🚀 Exemplos de uso

### Provisioned Cluster
```hcl
module "redshift" {
  source = "./modules/redshift-smart"

  mode               = "provisioned"
  cluster_identifier = "redshift-hml"
  node_type          = "ra3.xlplus"
  number_of_nodes    = 2
  database_name      = "dwh"
  master_username    = "admin"
  master_password    = var.redshift_master_password

  vpc_id     = "vpc-0123456789abcdef0"
  subnet_ids = ["subnet-aaa", "subnet-bbb"]

  create_subnet_group    = true
  subnet_group_name      = "rsg-hml"
  create_parameter_group = true
  parameter_group_name   = "rpg-hml"

  enable_logging        = true
  logging_bucket        = "my-redshift-logs"
  logging_s3_key_prefix = "clusters/hml/"

  tags = {
    Owner = "DataTeam"
  }
}
```

### Serverless
```hcl
module "redshift" {
  source = "./modules/redshift-smart"

  mode            = "serverless"
  namespace_name  = "ns-analytics-prd"
  workgroup_name  = "wg-analytics-prd"
  admin_username  = "admin"
  admin_user_password = var.redshift_admin_password
  database_name   = "analytics"

  vpc_id     = "vpc-0123456789abcdef0"
  subnet_ids = ["subnet-aaa", "subnet-bbb"]

  base_capacity = 16
  serverless_log_exports = ["userlog", "connectionlog"]

  tags = {
    Owner = "DataTeam"
  }
}
```

## ⚠️ Notas importantes
* Senhas → nunca hardcode. Use varfiles seguros, Terraform Cloud, ou AWS Secrets Manager.
* Acesso a S3 → configure iam_role_arns para COPY/UNLOAD/Spectrum.
* Rede privada → prefira subnets privadas com NAT Gateway para dependências externas.
* Criptografia → sempre via kms_key_id.
* Logs →
* * Cluster → S3.
* * Serverless → CloudWatch/S3 (via config no serviço).
* Janela de manutenção → use preferred_maintenance_window para clusters provisionados.

## 🔮 Roadmap
Possíveis extensões futuras:
* Snapshot schedules/copy (provisioned).
* Usage limits (serverless).
* Endpoint access dedicado.
* Custom domain association.