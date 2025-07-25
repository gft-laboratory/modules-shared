variable "enabled" {
  type        = bool
  default     = true
  description = "Se o recurso será criado ou não."
}

variable "job_name" {
  type        = string
  description = "Glue job name. If not provided, the name will be generated from the context."
  default     = null
}

variable "job_description" {
  type        = string
  description = "Glue job description."
  default     = null
}

variable "role_arn" {
  type        = string
  description = "The ARN of the IAM role associated with this job."
}

variable "connections" {
  type        = list(string)
  description = "The list of connections used for this job."
  default     = null
}

variable "glue_version" {
  type        = string
  description = "The version of Glue to use."
  default     = "2.0"
}

variable "glue_job_prefix" {
  type        = string
  description = "Prefixo base para o nome do Glue Job caso 'job_name' não seja informado."
  default     = null
}

variable "default_arguments" {
  type        = map(string)
  description = "The map of default arguments for the job. You can specify arguments here that your own job-execution script consumes, as well as arguments that AWS Glue itself consumes."
  default     = null
}

variable "non_overridable_arguments" {
  type        = map(string)
  description = "Non-overridable arguments for this job, specified as name-value pairs."
  default     = null
}

variable "security_configuration" {
  type        = string
  description = "The name of the Security Configuration to be associated with the job."
  default     = null
}

variable "timeout" {
  type        = number
  description = "The job timeout in minutes. The default is 2880 minutes (48 hours) for `glueetl` and `pythonshell` jobs, and `null` (unlimited) for `gluestreaming` jobs."
  default     = 2880
}

variable "max_capacity" {
  type        = number
  description = "The maximum number of AWS Glue data processing units (DPUs) that can be allocated when the job runs. Required when `pythonshell` is set, accept either 0.0625 or 1.0. Use `number_of_workers` and `worker_type` arguments instead with `glue_version` 2.0 and above."
  default     = null
}

variable "max_retries" {
  type        = number
  description = " The maximum number of times to retry the job if it fails."
  default     = null
}

variable "worker_type" {
  type        = string
  description = "The type of predefined worker that is allocated when a job runs. Accepts a value of `Standard`, `G.1X`, or `G.2X`."
  default     = null
}

variable "number_of_workers" {
  type        = number
  description = "The number of workers of a defined `worker_type` that are allocated when a job runs."
  default     = null
}

variable "command" {
  type        = map(any)
  description = "The command of the job."
}

variable "execution_property" {
  type = object({
    # The maximum number of concurrent runs allowed for the job. The default is 1.
    max_concurrent_runs = number
  })
  description = "Execution property of the job."
  default     = null
}

variable "notification_property" {
  type = object({
    # After a job run starts, the number of minutes to wait before sending a job run delay notification
    notify_delay_after = number
  })
  description = "Notification property of the job."
  default     = null
}

variable "tags" {
  type        = map(string)
  default     = {}
}
