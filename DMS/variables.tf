variable "replication_instance_id" {}
variable "replication_instance_class" {}
variable "allocated_storage" {}
variable "publicly_accessible" { default = false }
variable "vpc_security_group_ids" { type = list(string) }
variable "availability_zone" { default = null }
variable "subnet_group_name_id" {
    type        = string
    default     = null
    description = "This is a logical name for the subnet group, not a resource ID"
}
variable "subnet_group_description" {}
variable "subnet_ids" { type = list(string) }
variable "auto_minor_version_upgrade" { default = true }
variable "kms_key_arn" { type = string }


variable "source_endpoint_id" {}
variable "source_engine_name" {}
variable "source_username" {}
variable "source_password" {}
variable "source_server_name" {}
variable "source_port" {}
variable "source_database_name" {}

variable "target_endpoint_id" {}
variable "target_engine_name" {}
variable "target_username" {}
variable "target_password" {}
variable "target_server_name" {}
variable "target_port" {}
variable "target_database_name" {}

variable "replication_task_id" {}
variable "migration_type" {}
variable "table_mappings" {}
variable "replication_task_settings" {}

variable "tags" { type = map(string) }