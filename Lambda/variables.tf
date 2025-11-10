variable "function_name" {
  description = "Nome da função Lambda"
  type        = string
}

variable "role_arn" {
  description = "ARN da role que será assumida pela Lambda"
  type        = string
}

variable "handler" {
  description = "Nome do handler (ex: index.handler)"
  type        = string
}

variable "runtime" {
  description = "Runtime da Lambda (ex: nodejs18.x, python3.10, etc)"
  type        = string
}

variable "memory_size" {
  description = "Memória em MB alocada para a função"
  type        = number
  default     = 128
}

variable "timeout" {
  description = "Tempo máximo de execução da função (em segundos)"
  type        = number
  default     = 3
}

variable "filename" {
  description = "Caminho para o arquivo ZIP contendo o código da Lambda"
  type        = string
}

variable "environment_variables" {
  description = "Variáveis de ambiente da Lambda"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags para Lambda"
  type        = map(string)
  default     = {}
}

variable "environment_kms_key_arn" {
  description = "ARN da KMS Key para criptografar variáveis de ambiente"
  type        = string
  default     = null
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

variable "tracing_mode" {
  description = "Modo do X-Ray tracing (Active ou PassThrough)"
  type        = string
  default     = "PassThrough"
}

variable "reserved_concurrent_executions" {
  description = "Limite de execuções simultâneas da função Lambda"
  type        = number
  default     = -1  # -1 significa ilimitado
}

variable "enable_vpc" {
  description = "Se a função Lambda deve ser associada a uma VPC"
  type        = bool
  default     = false
}

variable "create_log_group" {
  description = "Se deve criar um Log Group para a função"
  type        = bool
  default     = true
}

variable "log_retention_in_days" {
  description = "Tempo de retenção dos logs em dias"
  type        = number
  default     = 30
}

variable "log_group_kms_key_arn" {
  description = "ARN da KMS Key usada para criptografar logs no CloudWatch"
  type        = string
  default     = null
}
