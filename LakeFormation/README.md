# Módulo Terraform - AWS Lake Formation

## 📌 O que é o AWS Lake Formation?
O **AWS Lake Formation** é um serviço que ajuda a configurar, proteger, gerenciar e compartilhar um *Data Lake* na AWS.
Ele integra com serviços como S3, Glue e Athena, permitindo:
- Controle centralizado de permissões
- Governança de dados baseada em tags
- Integração com Glue Data Catalog
- Auditoria de acessos

---

## 🛠 Estrutura do módulo
Este módulo permite:
- Definir administradores do Lake Formation
- Criar permissões para bancos de dados e tabelas
- Criar e associar **LF-Tags**
- Gerenciar permissões com *grant option*

### Arquivos:
- **`main.tf`** → Implementa os recursos AWS Lake Formation
- **`variables.tf`** → Define variáveis com descrições
- **`outputs.tf`** → Expõe informações úteis após o deploy
- **`README.md`** → Documentação do módulo

---

## 🚀 Como usar
```hcl
module "lakeformation" {
  source = "git::ssh://git@github.com/SEU_ORG/SEU_REPO.git//lakeformation?ref=v1.0.0"

  admins = [
    "arn:aws:iam::123456789012:role/AdminRole",
    "arn:aws:iam::123456789012:user/DataLakeAdmin"
  ]

  databases_permissions = [
    {
      name        = "db1-permission"
      principal   = "arn:aws:iam::123456789012:role/DataAnalyst"
      database_name = "meu_banco"
      permissions   = ["SELECT", "DESCRIBE"]
    }
  ]

  tables_permissions = [
    {
      database_name = "meu_banco"
      table_name    = "minha_tabela"
      principal     = "arn:aws:iam::123456789012:role/DataScientist"
      permissions   = ["SELECT"]
    }
  ]

  lf_tags = [
    {
      key    = "Confidencialidade"
      values = ["Alta", "Media", "Baixa"]
    }
  ]

  lf_tag_assignments = [
    {
      resource_type = "TABLE"
      resource_name = "minha_tabela"
      database_name = "meu_banco"
      tag_key       = "Confidencialidade"
      tag_value     = "Alta"
    }
  ]
}
```

# 📤 Saídas (outputs.tf)
* lakeformation_admins → Lista de administradores configurados
* lf_tags → Tags criadas
* lf_tags_assignment → Associações de tags
* databases_permissions → Permissões de bancos de dados
* tables_permissions → Permissões de tabelas

# 📚 Notas importantes
* Certifique-se de que o usuário/role que aplica o módulo tenha permissões lakeformation:* e glue:*.
* A criação de permissões exige que o recurso já exista no Glue Data Catalog.
* LF-Tags permitem controle fino de acesso baseado em metadados.