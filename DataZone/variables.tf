variable "domain_name" {
  description = "Nome do domínio do Amazon DataZone. Deve ser único na conta."
  type        = string
}

variable "project_name" {
  description = "Nome do projeto inicial a ser criado no domínio."
  type        = string
}

variable "project_description" {
  description = "Descrição para o projeto inicial."
  type        = string
  default     = "Projeto inicial gerenciado via Terraform."
}

variable "users" {
  description = "Lista de objetos de usuários para adicionar ao domínio. Cada objeto deve ter 'identifier' (ARN do IAM ou ID do SSO) e 'type' ('IAM_USER', 'IAM_ROLE' ou 'SSO_USER')."
  type = list(object({
    identifier = string
    type       = string
  }))
  default = []
  validation {
    condition = alltrue([
      for user in var.users : contains(["IAM_USER", "IAM_ROLE", "SSO_USER"], user.type)
    ])
    error_message = "O tipo de usuário deve ser 'IAM_USER', 'IAM_ROLE' ou 'SSO_USER'."
  }
}

variable "enabled_regions" {
  description = "Lista de regiões da AWS onde os ambientes podem ser provisionados."
  type        = list(string)
}

variable "glossary_name" {
  description = "Nome do glossário de negócios a ser criado."
  type        = string
  default     = "GlossarioPrincipal"
}

variable "glossary_initial_term_name" {
  description = "Nome de um termo inicial para criar no glossário. Deixe em branco para não criar nenhum."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Um mapa de tags para aplicar aos recursos que as suportam."
  type        = map(string)
  default     = {}
}


variable "domain_execution_role" {
  description = "Nome da role do dominio do DataZone"
  type        = string
}

variable "provisioning_role_arn" {
  description = "Nome da role do dominio do DataZone"
  type        = string
}

variable "enabled_blueprint_names" {
  description = "Lista de nomes dos blueprints 'Built-in' que devem ser habilitados."
  type        = list(string)
  default     = ["DefaultDataLake"] # Mantém um padrão
}

variable "name_prefix" {
  description = "Prefixo para nomear recursos"
  type        = string
  default = "dz"
}

variable "assets" {
  description = <<EOT
Lista de assets para criar. Exemplo:
[
  {
    name        = "meu-asset"
    type        = "S3_OBJECT"
    description = "Tabela do S3"
    owner       = "time-analytics"
    metadata    = { key1 = "value1", key2 = "value2" }
    tags        = { env = "dev" }
    prevent_destroy = false
  }
]
EOT
  type = list(object({
    name            = string
    type            = string
    description     = optional(string)
    owner           = optional(string)
    metadata        = optional(map(string))
    tags            = optional(map(string))
    prevent_destroy = optional(bool, false)
  }))
  default = []
}

variable "account_associations" {
  description = <<EOT
Lista de contas para associar ao domínio do DataZone com permissões RAM.
Exemplo:
[
  {
    account_id        = "804540873404"
    account_name      = "Data-Producer-Analytics-Dev"
    environment       = "development"
    subscription_type = "PRODUCER_CONSUMER"
    ram_policy = {
      name        = "ram-producer-datazone-policy"
      description = "Permissões para produtor"
      permissions = [
        "datazone:CreateProject",
        "datazone:ListProjects",
        "datazone:GetProject"
      ]
      resource_types = ["project", "dataset", "asset"]
    }
  }
]
EOT
  type = list(object({
    account_id        = string
    account_name      = string
    environment       = string
    subscription_type = string
    ram_policy = object({
      name          = string
      description   = string
      permissions   = list(string)
      resource_types = list(string)
    })
  }))
  default = []
}

variable "subnet_ids" {
  description = "Lista de subnets onde a Lambda será executada"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "Lista de Security Groups associados à Lambda"
  type        = list(string)
  default     = []
}

variable "dlq_target_arn" {
  description = "ARN do recurso Dead Letter Queue para Lambda"
  type        = string
  default     = ""
}


variable "enable_vpc" {
  description = "Se a função Lambda deve ser associada a uma VPC"
  type        = bool
  default     = true
}

