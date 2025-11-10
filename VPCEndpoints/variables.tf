variable "vpc_id" {
  description = "ID da VPC onde os endpoints serão criados"
  type        = string
}

variable "endpoints" {
  description = "Mapa com definições dos endpoints. Suporta múltiplos."
  type = map(object({
    service_name        = string
    vpc_endpoint_type   = string         # "Interface" ou "Gateway"
    subnet_ids          = optional(list(string))  # Para Interface
    route_table_ids     = optional(list(string))  # Para Gateway
    security_group_ids  = optional(list(string))  # Para Interface
    private_dns_enabled = optional(bool)
    policy              = optional(string)
    tags                = optional(map(string))
  }))
}

variable "default_tags" {
  description = "Tags padrão aplicadas a todos os endpoints"
  type        = map(string)
  default     = {}
}
