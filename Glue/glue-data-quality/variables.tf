variable "name" {
  description = "Nome do Glue Data Quality Ruleset"
  type        = string
}

variable "description" {
  description = "Descrição do Ruleset"
  type        = string
  default     = null
}

variable "ruleset" {
  description = "Regras do Data Quality em formato DQDL"
  type        = string
}

variable "database_name" {
  description = "Nome do banco de dados do Glue"
  type        = string
}

variable "table_name" {
  description = "Nome da tabela do Glue"
  type        = string
}

variable "tags" {
  description = "Tags a serem aplicadas"
  type        = map(string)
  default     = {}
}

variable "enable_evaluation_run" {
  description = "Define se será executado o evaluation run após a criação"
  type        = bool
  default     = false
}
