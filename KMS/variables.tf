variable "alias" {
  description = "Alias for the KMS key"
  type        = string
}

variable "description" {
  description = "Description of the KMS key"
  type        = string
  default     = "KMS key managed by Terraform"
}

variable "enable_key_rotation" {
  description = "Specifies whether key rotation is enabled"
  type        = bool
  default     = true
}

variable "is_enabled" {
  description = "Specifies whether the key is enabled"
  type        = bool
  default     = true
}

variable "deletion_window_in_days" {
  description = "Number of days before key is deleted after destruction"
  type        = number
  default     = 30
}

variable "multi_region" {
  description = "Specifies whether the KMS key is a multi-Region key"
  type        = bool
  default     = false
}

variable "kms_policy" {
  description = "Optional JSON policy to attach to the key"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
