###################################
# Variables - Athena Module
###################################

variable "create_results_bucket" {
  type        = bool
  description = "Se true, é obrigatório informar bucket_athena para armazenar resultados do Athena."
  default     = false
}

variable "bucket_athena" {
  type        = string
  description = "Nome do bucket externo para armazenar resultados do Athena (criado fora do módulo)."
  default     = null
}

variable "results_bucket_name" {
  description = "Nome do bucket S3 para resultados do Athena (se create_results_bucket=true)"
  type        = string
  default     = null
}

variable "workgroups" {
  description = "Lista de WorkGroups do Athena a serem criados"
  type = list(object({
    name                  = string
    description           = optional(string, null)
    state                 = optional(string, "ENABLED")
    enforce_configuration = optional(bool, true)
    enable_cloudwatch     = optional(bool, true)
    output_location       = optional(string, null)
    encryption_option     = optional(string, "SSE_S3")
  }))
  default = []
}

variable "named_queries" {
  description = "Lista de Named Queries a serem criadas no Athena"
  type = list(object({
    name        = string
    description = optional(string, null)
    database    = string
    query       = string
    workgroup   = optional(string, null)
  }))
  default = []
}

variable "capacity_reservations" {
  description = "Lista de Capacity Reservations para Athena"
  type = list(object({
    name        = string
    target_dpus = number
    workgroup_names = list(string)
  }))
  default = []
}


variable "data_sources_catalogs" {
  description = "Lista de Data Catalogs adicionais para Athena (Data Sources)"
  type = list(object({
    name        = string
    type        = string                # LAMBDA, GLUE, HIVE, JDBC
    description = optional(string, null)
    parameters  = optional(map(string), {})
  }))
  default = []
}

variable "tags" {
  description = "Tags adicionais para os recursos"
  type        = map(string)
  default     = {}
}