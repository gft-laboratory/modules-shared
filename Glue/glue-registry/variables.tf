variable "registry_name" {
  type        = string
  description = "Glue registry name. If not provided, the name will be generated from the context."
  default     = null
}

variable "registry_description" {
  type        = string
  description = "Glue registry description."
  default     = null
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Define se o recurso será criado ou não."
}