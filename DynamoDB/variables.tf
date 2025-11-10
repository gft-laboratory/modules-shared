variable "table_name" {
  type = string
}

variable "partition_key_name" {
  type = string
}

variable "partition_key_type" {
  type        = string
  description = "Type of the partition key. For example: S (String), N (Number), B (Binary)"
}

variable "sort_key_name" {
  type    = string
  default = null
}

variable "sort_key_type" {
  type        = string
  default     = null
  description = "Type of the sort key. For example: S (String), N (Number), B (Binary)"
}

variable "point_in_time_recovery_enabled" {
  type    = bool
  default = true
  description = "Enable or disable Point-in-Time Recovery (PITR) for the DynamoDB table"
}

# Alterado para ser específico do DynamoDB Streams
variable "dynamodb_stream_enabled" {
  type    = bool
  default = false
  description = "Enable native DynamoDB Streams on the table."
}

variable "kinesis_stream_enabled" {
  type    = bool
  default = false
  description = "Enable streaming to a Kinesis Data Stream."
}

variable "stream_view_type" {
  type        = string
  default     = null
  description = "Valid values: KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES"

  validation {
    condition = (
      var.stream_view_type == null ||
      can(contains(["KEYS_ONLY", "NEW_IMAGE", "OLD_IMAGE", "NEW_AND_OLD_IMAGES"], var.stream_view_type))
    )
    error_message = "stream_view_type deve ser nulo ou um dos valores: KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES."
  }
}

variable "tags_dynamodb" {
  type    = map(string)
  default = {
    "terraform" = "true"
    "backup"    = "dynamodb"
  }
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "kinesis_stream_name" {
  type    = string
  default = null
}

variable "kinesis_shard_count" {
  type    = number
  default = 1
}

variable "kinesis_retention_period" {
  type    = number
  default = 24
}

variable "kms_key_arn" {
  type        = string
  default     = null
  description = "The KMS Key ARN to encrypt data at rest"
}

variable "encryption_type" {
  type        = string
  default     = "KMS"
  description = "Encryption type for Kinesis stream. Valid values: KMS, NONE."
}
