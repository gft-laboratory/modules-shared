# Módulo Terraform — AWS OpenSearch (Elasticsearch)

Este módulo cria e gerencia um **domínio do Amazon OpenSearch Service** (antigo Elasticsearch) na AWS.  
Ele é **flexível, seguro e inteligente**, permitindo configurar:
- Cluster VPC ou público.
- Criptografia em repouso e entre nós.
- Controle de acesso com políticas JSON ou segurança avançada.
- Logs no CloudWatch.
- Endpoints customizados com certificados ACM.

Ideal para uso em **pipelines DevOps**, **Data Lakes**, **observabilidade** ou **aplicações analíticas**.

---

## Exemplo de Uso Básico

```hcl
module "opensearch" {
  source = "../OpenSearchService"

  domain_name    = "pj-domain"
  engine_version = "OpenSearch_2.11"
  ambiente       = "dev"
  projeto        = "teste_pj"

  instance_type  = "t3.medium.search"
  instance_count = 2

  subnet_ids         = ["subnet-0abcd1234", "subnet-0efgh5678"]
  security_group_ids = ["sg-0123456789abcdef"]

  ebs_volume_type  = "gp3"
  ebs_volume_size  = 50

  encrypt_at_rest_enabled         = true
  node_to_node_encryption_enabled = true

  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = { AWS = "*" }
        Action   = "es:*"
        Resource = "*"
      }
    ]
  })

  tags = {
    Environment = "dev"
    IaC         = "Terraform"
  }
}
```

## Exemplo Avançado com Segurança e Logs

```hcl
module "opensearch_secure" {
  source = "./OpenSearchService"

  domain_name   = "secure-logs-domain"
  engine_version = "OpenSearch_2.11"

  instance_type  = "r6g.large.search"
  instance_count = 3

  vpc_options = {
    subnet_ids         = ["subnet-1", "subnet-2"]
    security_group_ids = ["sg-secure"]
  }

  advanced_security_enabled        = true
  internal_user_database_enabled   = true
  master_user_name                 = "admin"
  master_user_password             = "SuperSecretPass123!"

  log_index_slow_enabled  = true
  log_search_slow_enabled = true
  log_es_audit_enabled    = true
  cloudwatch_log_group_arn = "arn:aws:logs:us-east-1:111111111111:log-group:/aws/opensearch/secure-domain:*"

  encrypt_at_rest_enabled = true
  node_to_node_encryption = true

  access_policies = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = { AWS = "arn:aws:iam::111111111111:role/MyAppRole" }
        Action   = "es:*"
        Resource = "*"
      }
    ]
  })

  tags = {
    Environment = "prd"
    Owner       = "CloudOps"
    CostCenter  = "Analytics"
  }
}
```

## Explicação do Módulo
| Recurso                                              | Descrição                                                                                       |
| ---------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| **aws_opensearch_domain**                            | Cria o domínio principal do OpenSearch com todas as configurações de cluster, segurança e rede. |
| **aws_opensearch_domain_policy**                     | Define as políticas de acesso do domínio via JSON, permitindo controle granular.                |
| **Criptografia e TLS**                               | O módulo habilita HTTPS, criptografia em repouso (KMS) e entre nós para proteger os dados.      |
| **VPC**                                              | Suporte completo para execução privada dentro de subnets e security groups definidos.           |
| **Logs no CloudWatch**                               | É possível enviar logs de indexação lenta, busca lenta e auditoria para um Log Group.           |
| **Segurança Avançada (Fine-Grained Access Control)** | Permite configurar autenticação interna e controle de acesso por usuário via master user.       |
| **Tags**                                             | Todas as tags são aplicadas automaticamente a todos os recursos.                                |


## Estrutura dos Arquivos do Módulo

```
/OpenSearchService
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md
```


# Documentação Técnica


## Requirements
| Name      | Version  |
| --------- | -------- |
| terraform | >= 1.5.0 |
| aws       | >= 5.0   |

## Providers
| Name | Version |
| ---- | ------- |
| aws  | >= 5.0  |

## Inputs
| Name                            | Description                                        | Type           | Default                        | Required |
| ------------------------------- | -------------------------------------------------- | -------------- | ------------------------------ | :------: |
| domain_name                     | Nome do domínio OpenSearch.                        | `string`       | n/a                            |     ✅    |
| engine_version                  | Versão do mecanismo OpenSearch/Elasticsearch.      | `string`       | `"OpenSearch_2.11"`            |     ❌    |
| instance_type                   | Tipo de instância dos nós de dados.                | `string`       | `"t3.small.search"`            |     ❌    |
| instance_count                  | Quantidade de instâncias no cluster.               | `number`       | `2`                            |     ❌    |
| dedicated_master_enabled        | Habilita nós mestres dedicados.                    | `bool`         | `false`                        |     ❌    |
| dedicated_master_type           | Tipo de instância dos nós mestres.                 | `string`       | `"t3.small.search"`            |     ❌    |
| dedicated_master_count          | Quantidade de nós mestres dedicados.               | `number`       | `3`                            |     ❌    |
| zone_awareness_enabled          | Habilita zone awareness para alta disponibilidade. | `bool`         | `true`                         |     ❌    |
| availability_zone_count         | Quantidade de zonas de disponibilidade.            | `number`       | `2`                            |     ❌    |
| ebs_enabled                     | Habilita armazenamento EBS.                        | `bool`         | `true`                         |     ❌    |
| ebs_volume_type                 | Tipo de volume EBS (gp3, gp2, etc).                | `string`       | `"gp3"`                        |     ❌    |
| ebs_volume_size                 | Tamanho do volume EBS (em GB).                     | `number`       | `20`                           |     ❌    |
| encrypt_at_rest_enabled         | Habilita criptografia em repouso.                  | `bool`         | `true`                         |     ❌    |
| kms_key_id                      | ID da chave KMS usada para criptografia.           | `string`       | `null`                         |     ❌    |
| node_to_node_encryption         | Habilita criptografia entre nós.                   | `bool`         | `true`                         |     ❌    |
| enforce_https                   | Força o uso de HTTPS.                              | `bool`         | `true`                         |     ❌    |
| tls_security_policy             | Política TLS mínima.                               | `string`       | `"Policy-Min-TLS-1-2-2019-07"` |     ❌    |
| custom_endpoint_enabled         | Habilita endpoint customizado.                     | `bool`         | `false`                        |     ❌    |
| custom_endpoint                 | Endpoint customizado (CNAME).                      | `string`       | `null`                         |     ❌    |
| custom_endpoint_certificate_arn | ARN do certificado ACM.                            | `string`       | `null`                         |     ❌    |
| advanced_security_enabled       | Habilita controle de acesso avançado.              | `bool`         | `false`                        |     ❌    |
| internal_user_database_enabled  | Habilita banco interno de usuários.                | `bool`         | `false`                        |     ❌    |
| master_user_arn                 | ARN do usuário mestre.                             | `string`       | `null`                         |     ❌    |
| master_user_name                | Nome do usuário mestre (interno).                  | `string`       | `null`                         |     ❌    |
| master_user_password            | Senha do usuário mestre.                           | `string`       | `null`                         |     ❌    |
| subnet_ids                      | Subnets da VPC.                                    | `list(string)` | `[]`                           |     ❌    |
| security_group_ids              | Security groups associados.                        | `list(string)` | `[]`                           |     ❌    |
| log_index_slow_enabled          | Habilita logs de indexação lenta.                  | `bool`         | `false`                        |     ❌    |
| log_search_slow_enabled         | Habilita logs de busca lenta.                      | `bool`         | `false`                        |     ❌    |
| log_es_audit_enabled            | Habilita logs de auditoria.                        | `bool`         | `false`                        |     ❌    |
| cloudwatch_log_group_arn        | ARN do Log Group do CloudWatch.                    | `string`       | `null`                         |     ❌    |
| access_policies                 | Política de acesso JSON.                           | `string`       | `""`                           |     ❌    |
| tags                            | Tags adicionais aplicadas aos recursos.            | `map(string)`  | `{}`                           |     ❌    |

## Outputs
| Name                  | Description                  |
| --------------------- | ---------------------------- |
| domain_arn            | ARN do domínio OpenSearch.   |
| domain_endpoint       | Endpoint público do domínio. |
| domain_id             | ID do domínio OpenSearch.    |
| domain_name           | Nome do domínio criado.      |
| domain_endpoint_https | Endpoint HTTPS completo.     |

