variable "create_event_bus" {
  type        = bool
  default     = true
  description = "Se verdadeiro, cria um Event Bus customizado. Caso falso, utiliza um Event Bus existente."
}

variable "event_bus_name" {
  type        = string
  description = "Nome do Event Bus. Obrigatório se create_event_bus = true ou se estiver usando um já existente."
}

variable "event_rules" {
  type = list(object({
    name                = string
    description         = optional(string)
    event_pattern       = optional(string)
    schedule_expression = optional(string)
    role_arn            = optional(string)
    is_enabled          = optional(bool, true)
  }))
  default     = []
  description = "Lista de regras do EventBridge. Pode conter padrão de eventos ou expressão de agendamento."
}

variable "event_targets" {
  type = list(object({
    rule_name  = string
    target_id  = string
    arn        = string
    input      = optional(string)
    role_arn   = optional(string)
  }))
  default     = []
  description = "Lista de destinos (targets) para as regras definidas no EventBridge."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags a serem aplicadas aos recursos criados."
}
