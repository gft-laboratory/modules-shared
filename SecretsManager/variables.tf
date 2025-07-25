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

variable "enable_rotation" {
  description = "Se habilita a rotação automática do segredo"
  type        = bool
  default     = false
}

variable "rotation_lambda_arn" {
  description = "ARN da função Lambda que executa a rotação do segredo"
  type        = string
  default     = null
}

variable "automatically_after_days" {
  description = "Número de dias entre rotações automáticas"
  type        = number
  default     = 30
}
