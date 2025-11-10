variable "name" {
  description = "Nome da Step Function"
  type        = string
}

variable "role_arn" {
  description = "ARN da IAM Role que a Step Function assumirá"
  type        = string
}

variable "definition" {
  description = "Definição da Step Function em Amazon States Language (JSON)"
  type        = string
}

variable "state_machine_type" {
  description = "Tipo da máquina de estado (STANDARD ou EXPRESS)"
  type        = string
  default     = "STANDARD"
  validation {
    condition     = contains(["STANDARD", "EXPRESS"], var.state_machine_type)
    error_message = "O tipo deve ser STANDARD ou EXPRESS"
  }
}

variable "logging_level" {
  description = "Nível de logging (ALL, ERROR, FATAL, OFF)"
  type        = string
  default     = "OFF"
}

variable "include_execution_data" {
  description = "Se deve incluir os dados de execução no log"
  type        = bool
  default     = false
}

variable "cloudwatch_log_group_arn" {
  description = "ARN do grupo de log do CloudWatch para logging"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags para os recursos"
  type        = map(string)
  default     = {}
}

variable "enable_tracing" {
  description = "Habilita o X-Ray tracing na Step Function"
  type        = bool
  default     = true
}
