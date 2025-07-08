variable "bucket_name" {
  type    = string
  default = ""
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "bucket_log_name" {
  type    = string
  default = ""
}

variable "create_bucket_policy" {
  type    = bool
  default = false
}

variable "tags_bucket" {
  type    = map(string)
  default = null
}

variable "create_lifecycle" {
  description = "Flag to create S3 bucket lifecycle configuration"
  type        = bool
  default     = false
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules"
  type = list(object({
    id                           = string
    expiration                   = number
    prefix                       = string
    transitions                  = list(object({
      days          = number
      storage_class = string
    }))
    noncurrent_version_expiration = number
    noncurrent_version_transitions = list(object({
      noncurrent_days = number
      storage_class   = string
    }))
  }))
  default = []
}