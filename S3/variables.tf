variable "bucket_name" {
  type    = string
  default = ""
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "bucket_log_name" {
  type    = string
  default = ""
}

variable "create_bucket_policy" {
  type    = bool
  default = false
}

variable "tags_bucket" {
  type    = map(string)
  default = null
}

variable "create_lifecycle" {
  description = "Flag to create S3 bucket lifecycle configuration"
  type        = bool
  default     = false
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules"
  type = list(object({
    id                           = string
    expiration                   = number
    prefix                       = string
    transitions                  = list(object({
      days          = number
      storage_class = optional(string, "STANDARD_IA")
    }))
    noncurrent_version_expiration  = optional(number)
    noncurrent_version_transitions = list(object({
      noncurrent_days = number
      storage_class   = string
    }))
    abort_incomplete_multipart_upload_days = optional(number)
  }))
  default = []
}

variable "kms_key_id" {
  description = "ARN da chave KMS para criptografia do bucket S3"
  type        = string
}

variable "enable_versioning" {
  description = "Habilita o versionamento no bucket S3"
  type        = bool
  default     = false
}

variable "enable_notification" {
  description = "Habilita notificação no bucket S3"
  type        = bool
  default     = false
}

variable "notification_lambda_arn" {
  description = "ARN da função Lambda para notificação"
  type        = string
  default     = ""
}

variable "notification_lambda_name" {
  description = "Nome da função Lambda para configurar permissão"
  type        = string
  default     = ""
}

variable "notification_prefix" {
  description = "Prefixo do filtro de eventos para notificação"
  type        = string
  default     = ""
}

variable "notification_suffix" {
  description = "Sufixo do filtro de eventos para notificação"
  type        = string
  default     = ""
}

variable "bucket_policy" {
  description = "Conteúdo JSON da policy do bucket S3 para aplicar"
  type        = string
  default     = null
}