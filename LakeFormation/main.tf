# Configuração de administradores do Lake Formation
resource "aws_lakeformation_data_lake_settings" "this" {
  admins = var.admins
}

# Permissões de banco de dados
resource "aws_lakeformation_permissions" "databases" {
  for_each = { for db in var.databases_permissions : db.name => db }

  principal   = each.value.principal
  permissions = each.value.permissions
  permissions_with_grant_option = lookup(each.value, "permissions_with_grant_option", [])

  database {
    name = each.value.database_name
  }

  lifecycle {
    ignore_changes = [
      permissions,
      permissions_with_grant_option
    ]
  }
}

# Permissões de tabelas
resource "aws_lakeformation_permissions" "tables" {
  for_each = { for tbl in var.tables_permissions : "${tbl.database_name}.${tbl.table_name}" => tbl }

  principal   = each.value.principal
  permissions = each.value.permissions
  permissions_with_grant_option = lookup(each.value, "permissions_with_grant_option", [])

  table {
    database_name = each.value.database_name
    name          = each.value.table_name
  }
}

# Tags do Lake Formation
resource "aws_lakeformation_lf_tag" "tags" {
  for_each = { for tag in var.lf_tags : tag.key => tag }

  key    = each.value.key
  values = each.value.values
}

# Validando e filtrando entradas de LF Tag Assignments
locals {
  safe_lf_tag_assignments = [
    for ta in var.lf_tag_assignments : ta
    if (
      lookup(ta, "resource_type", "") != "" &&
      lookup(ta, "resource_name", "") != "" &&
      lookup(ta, "tag_key", "") != "" &&
      lookup(ta, "tag_value", "") != "" &&
      (lookup(ta, "resource_type", "") != "TABLE" || lookup(ta, "database_name", "") != "")
    )
  ]
}


# Associações de LF-Tags a recursos (suporte TABLE, DATABASE e COLUMN)
resource "aws_lakeformation_resource_lf_tags" "tags_assignment" {
  for_each = { for ta in local.safe_lf_tag_assignments : "${ta.resource_type}-${ta.resource_name}" => ta }

  dynamic "database" {
    for_each = each.value.resource_type == "DATABASE" ? [1] : []
    content {
      name = each.value.resource_name
    }
  }

  dynamic "table" {
    for_each = each.value.resource_type == "TABLE" ? [1] : []
    content {
      database_name = each.value.database_name
      name          = each.value.resource_name
    }
  }

  lf_tag {
    key   = each.value.tag_key
    value = each.value.tag_value
  }
}
