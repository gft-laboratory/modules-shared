variable "connection_name" {
  type        = string
  description = "Connection name. If not provided, the name will be generated from the context."
  default     = null
}

variable "connection_description" {
  type        = string
  description = "Connection description."
  default     = null
}

variable "catalog_id" {
  type        = string
  description = "The ID of the Data Catalog in which to create the connection. If none is supplied, the AWS account ID is used by default."
  default     = null
}

variable "connection_type" {
  type        = string
  description = "The type of the connection. Supported are: JDBC, MONGODB, KAFKA, and NETWORK. Defaults to JBDC"

  validation {
    condition     = contains(["JDBC", "MONGODB", "KAFKA", "NETWORK"], var.connection_type)
    error_message = "Supported are: JDBC, MONGODB, KAFKA, and NETWORK."
  }
}

variable "connection_properties" {
  type        = map(string)
  description = "A map of key-value pairs used as parameters for this connection."
  default     = null
}

variable "match_criteria" {
  type        = list(string)
  description = "A list of criteria that can be used in selecting this connection."
  default     = null
}

variable "physical_connection_requirements" {
  type = object({
    availability_zone      = string
    security_group_id_list = list(string)
    subnet_id              = string
  })
  default     = null
  description = "Configuração da conexão física, incluindo AZ, SGs e Subnet."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Define se o recurso será criado ou não."
}

variable "name_prefix" {
  type        = string
  default     = null
  description = "Prefixo usado no nome da conexão se 'connection_name' não for fornecido."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags a serem aplicadas ao recurso."
}