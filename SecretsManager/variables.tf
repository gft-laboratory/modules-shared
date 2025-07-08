variable "secret_name" {
  description = "Nome do segredo"
  type        = string
}

variable "description" {
  description = "Descrição do segredo"
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "KMS Key ID usada para criptografar o segredo (opcional)"
  type        = string
  default     = null
}

variable "secret_value" {
  description = "Valor do segredo em formato string (JSON ou string simples)"
  type        = string
}

variable "tags" {
  description = "Tags aplicadas ao segredo"
  type        = map(string)
  default     = {}
}
