variable "policy_name" {
  type        = string
  description = "Nome da política IAM customizada"
}

variable "policy_description" {
  type        = string
  description = "Descrição da política IAM customizada"
  default     = ""
}

variable "policy_path" {
  type        = string
  description = "Caminho da política IAM"
  default     = "/"
}

variable "policy_document" {
  type        = string
  description = "Documento JSON com a política customizada (usado para criar uma policy)"
  default     = null
}

variable "policy_managed_arn" {
  type        = string
  description = "ARN de uma policy gerenciada da AWS a ser anexada à role"
  default     = null
}

variable "role_attach_policy_managed_name" {
  type        = string
  description = "Nome da IAM Role à qual a policy será anexada"
  default     = null
}