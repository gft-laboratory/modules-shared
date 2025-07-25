variable "enabled" {
  type        = bool
  default     = true
  description = "Se o recurso será criado ou não"
}

variable "trigger_name" {
  type        = string
  description = "Glue trigger name. If not provided, the name will be generated from the context."
  default     = null
}

variable "trigger_description" {
  type        = string
  description = "Glue trigger description."
  default     = null
}

variable "workflow_name" {
  type        = string
  description = "A workflow to which the trigger should be associated to."
  default     = null
}

variable "type" {
  type        = string
  description = "The type of trigger. Options are CONDITIONAL, SCHEDULED, ON_DEMAND or EVENT."
  default     = "CONDITIONAL"

  validation {
    condition     = contains(["CONDITIONAL", "SCHEDULED", "ON_DEMAND", "EVENT"], var.type)
    error_message = "Supported options are CONDITIONAL, SCHEDULED, ON_DEMAND or EVENT."
  }
}

variable "actions" {
  type        = list(any)
  description = "List of actions initiated by the trigger when it fires."
}

variable "predicate" {
  type        = any
  description = "A predicate to specify when the new trigger should fire. Required when trigger type is `CONDITIONAL`."
  default     = null
}

variable "event_batching_condition" {
  type        = map(number)
  description = "Batch condition that must be met (specified number of events received or batch time window expired) before EventBridge event trigger fires."
  default     = null
}

variable "schedule" {
  type        = string
  description = "Cron formatted schedule. Required for triggers with type `SCHEDULED`."
  default     = null
}

variable "trigger_enabled" {
  type        = bool
  description = "Whether to start the created trigger."
  default     = true
}

variable "start_on_creation" {
  type        = bool
  description = "Set to `true` to start `SCHEDULED` and `CONDITIONAL` triggers when created. `true` is not supported for `ON_DEMAND` triggers."
  default     = true
}

variable "tags" {
  type        = map(string)
  default     = {}
}