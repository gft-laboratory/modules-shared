variable "enabled" {
  type        = bool
  default     = true
  description = "Define se o recurso será criado ou não."
}

variable "catalog_table_name" {
  type        = string
  description = "Name of the table."
  default     = null
}

variable "name_prefix" {
  type        = string
  default     = null
  description = "Prefixo para o nome da tabela se catalog_table_name não for fornecido."
}

variable "catalog_table_description" {
  type        = string
  description = "Description of the table."
  default     = null
}

variable "database_name" {
  type        = string
  description = "Name of the metadata database where the table metadata resides."
}

variable "catalog_id" {
  type        = string
  description = "ID of the Glue Catalog and database to create the table in. If omitted, this defaults to the AWS Account ID plus the database name."
  default     = null
}

variable "owner" {
  type        = string
  description = "Owner of the table."
  default     = null
}

variable "parameters" {
  type        = map(string)
  description = "Properties associated with this table, as a map of key-value pairs."
  default     = null
}

variable "partition_index" {
  type = object({
    index_name = string
    keys       = list(string)
  })
  description = "Configuration block for a maximum of 3 partition indexes."
  default     = null
}

variable "partition_keys" {
  type        = map(any)
  description = "Configuration block of columns by which the table is partitioned. Only primitive types are supported as partition keys."
  default     = {}
}

variable "retention" {
  type        = number
  description = "Retention time for the table."
  default     = null
}

variable "table_type" {
  type        = string
  description = "Type of this table (`EXTERNAL_TABLE`, `VIRTUAL_VIEW`, etc.). While optional, some Athena DDL queries such as `ALTER TABLE` and `SHOW CREATE TABLE` will fail if this argument is empty."
  default     = null
}

variable "target_table" {
  type = object({
    catalog_id    = string
    database_name = string
    name          = string
  })
  description = "Configuration block of a target table for resource linking."
  default     = null
}

variable "view_expanded_text" {
  type        = string
  description = "If the table is a view, the expanded text of the view; otherwise null."
  default     = null
}

variable "view_original_text" {
  type        = string
  description = "If the table is a view, the original text of the view; otherwise null."
  default     = null
}

variable "storage_descriptor" {
  type        = any
  description = "Configuration block for information about the physical storage of this table."
  default     = null
}

variable "lakeformation_permissions_enabled" {
  description = "Enable Lake Formation permissions for the Glue table"
  type        = bool
  default     = false
}

variable "glue_role_arn" {
  description = "ARN of the IAM role that will be granted permissions"
  type        = string
}