variable "iam_role_permissions_boundary" {
  description = "ARN da política usada para definir o limite de permissões para a função do IAM"
  type        = string
  default     = null
}

variable "name" {
  type    = string
}

variable "tags_iam_role" {
  type    = map(string)
  default = null
}

variable "assume_role_policy" {
  description = "JSON de assume role policy para a IAM Role"
  type        = string
}

variable "managed_policy_arns" {
  type        = list(string)
  default     = null
  description = "Lista de ARNs de policies gerenciadas que serão anexadas à role. Se não for definida, nenhuma policy será anexada automaticamente."
}
