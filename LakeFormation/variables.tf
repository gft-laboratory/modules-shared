variable "admins" {
  description = "Lista de ARNs dos administradores do Lake Formation."
  type        = list(string)
  default     = []
}

variable "databases_permissions" {
  description = <<EOT
Lista de permissões para bancos de dados.
Cada item deve conter:
- name (identificador único)
- principal (ARN do usuário/grupo/role)
- database_name
- permissions (lista de permissões)
- permissions_with_grant_option (opcional)
EOT
  type = list(object({
    name                           = string
    principal                      = string
    database_name                  = string
    permissions                    = list(string)
    permissions_with_grant_option  = optional(list(string), [])
  }))
  default = []
}

variable "tables_permissions" {
  description = <<EOT
Lista de permissões para tabelas.
Cada item deve conter:
- database_name
- table_name
- principal
- permissions
- permissions_with_grant_option (opcional)
EOT
  type = list(object({
    database_name                  = string
    table_name                     = string
    principal                      = string
    permissions                    = list(string)
    permissions_with_grant_option  = optional(list(string), [])
  }))
  default = []
}

variable "lf_tags" {
  description = "Lista de tags do Lake Formation."
  type = list(object({
    key    = string
    values = list(string)
  }))
  default = []
}

variable "lf_tag_assignments" {
  description = <<EOT
Lista de associações de tags a recursos no Lake Formation.
Para tabelas, é necessário informar:
- database_name
- resource_name (nome da tabela)
- tag_key
- tag_value
EOT
  type = list(object({
    database_name = string
    resource_name = string
    tag_key       = string
    tag_value     = string
  }))
  default = []
}