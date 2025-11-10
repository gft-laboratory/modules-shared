# Módulo Terraform - AWS Athena

## 📖 Visão Geral
O **Amazon Athena** é um serviço de consulta interativa que permite executar queries SQL diretamente sobre dados armazenados no **Amazon S3**.  
Ele elimina a necessidade de provisionar servidores ou bancos de dados, sendo **serverless** e cobrando apenas pelas consultas realizadas.

Com o Athena você pode:
- Consultar dados no S3 usando SQL.
- Criar **WorkGroups** para separar workloads, controlar custos e aplicar governança.
- Criar **Named Queries** para padronizar consultas reutilizáveis.
- Integrar com **AWS Glue Data Catalog** para metadados e schema.

Este módulo foi projetado para ser **completo, flexível e reutilizável**, permitindo criar WorkGroups, Named Queries e buckets de resultados de forma simples.

---

## 📂 Estrutura do Módulo
- **main.tf** → definição dos recursos Athena (WorkGroups, Named Queries e bucket de resultados).  
- **variables.tf** → variáveis configuráveis do módulo.  
- **outputs.tf** → exporta informações úteis, como WorkGroups criados e bucket de resultados.  
- **README.md** → documentação e guia de uso.  

---

## ⚙️ Variáveis Principais
### Bucket de Resultados
- `create_results_bucket` → Cria ou não um bucket para armazenar os resultados.  
- `results_bucket_name` → Nome do bucket (caso não seja criado pelo módulo).  

### WorkGroups
```hcl
workgroups = [
  {
    name                  = "analytics"
    description           = "WorkGroup para análises gerais"
    state                 = "ENABLED"
    enforce_configuration = true
    enable_cloudwatch     = true
    output_location       = "s3://meu-bucket-athena-results/"
    encryption_option     = "SSE_S3"
  }
]
```

### Named Queries
```hcl
named_queries = [
  {
    name        = "consulta_clientes"
    description = "Lista clientes ativos"
    database    = "clientes_db"
    query       = "SELECT * FROM clientes WHERE status = 'ativo';"
    workgroup   = "analytics"
  }
]
```

# 🚀 Exemplo de Uso
```hcl
module "athena" {
  source = "./modules/athena"

  create_results_bucket = true
  results_bucket_name   = "meu-athena-results"

  workgroups = [
    {
      name                  = "analytics"
      description           = "WorkGroup para BI"
      state                 = "ENABLED"
      enforce_configuration = true
      enable_cloudwatch     = true
      encryption_option     = "SSE_S3"
    }
  ]

  named_queries = [
    {
      name        = "consulta_vendas"
      description = "Consulta de vendas do último mês"
      database    = "vendas_db"
      query       = "SELECT * FROM vendas WHERE data >= date_trunc('month', current_date - interval '1' month);"
      workgroup   = "analytics"
    }
  ]

  tags = {
    Projeto = "DataLake"
    Owner   = "Time-Data"
  }
}
```

# 📤 Outputs
* athena_workgroups → WorkGroups criados.
* athena_named_queries → Named Queries criadas.
results_bucket → Nome do bucket de resultados usado.

# 🏆 Benefícios do Módulo
* Estrutura padronizada e reutilizável.
* Suporte a múltiplos WorkGroups e Named Queries.
* Integração automática com bucket de resultados.
* Segurança com opções de criptografia.
* Tags centralizadas para governança.