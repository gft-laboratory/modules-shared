variable "crawler_name" {
  type        = string
  description = "Glue crawler name. If not provided, the name will be generated from the context."
  default     = null
}

variable "crawler_description" {
  type        = string
  description = "Glue crawler description."
  default     = null
}

variable "database_name" {
  type        = string
  description = "Glue catalog database."
}

variable "role" {
  type        = string
  description = "The IAM role friendly name (including path without leading slash), or ARN of an IAM role, used by the crawler to access other resources."
}

variable "schedule" {
  type        = string
  description = "A cron expression for the schedule."
  default     = null
}

variable "classifiers" {
  type        = list(string)
  description = "List of custom classifiers. By default, all AWS classifiers are included in a crawl, but these custom classifiers always override the default classifiers for a given classification."
  default     = null
}

variable "configuration" {
  type        = string
  description = "JSON string of configuration information."
  default     = null
}

variable "jdbc_target" {
  type        = list(any)
  description = "List of nested JBDC target arguments."
  default     = null
}

variable "dynamodb_target" {
  type        = list(any)
  description = "List of nested DynamoDB target arguments."
  default     = null
}

variable "s3_target" {
  type        = list(any)
  description = "List of nested Amazon S3 target arguments."
  default     = null
}

variable "mongodb_target" {
  type        = list(any)
  description = "List of nested MongoDB target arguments."
  default     = null
}

variable "catalog_target" {
  type = list(object({
    database_name = string
    tables        = list(string)
  }))
  description = "List of nested Glue catalog target arguments."
  default     = null
}

variable "delta_target" {
  type = list(object({
    connection_name = string
    delta_tables    = list(string)
    write_manifest  = bool
  }))
  description = "List of nested Delta target arguments."
  default     = null
}

variable "table_prefix" {
  type        = string
  description = "The table prefix used for catalog tables that are created."
  default     = null
}

variable "security_configuration" {
  type        = string
  description = "The name of Security Configuration to be used by the crawler."
  default     = null
}

variable "schema_change_policy" {
  type        = map(string)
  description = "Policy for the crawler's update and deletion behavior."
  default     = null
}

variable "lineage_configuration" {
  type = object({
    crawler_lineage_settings = string
  })
  description = "Specifies data lineage configuration settings for the crawler."
  default     = null
}

variable "recrawl_policy" {
  type = object({
    recrawl_behavior = string
  })
  description = "A policy that specifies whether to crawl the entire dataset again, or to crawl only folders that were added since the last crawler run."
  default     = null
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Define se o recurso será criado ou não."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags aplicadas ao recurso."
}
