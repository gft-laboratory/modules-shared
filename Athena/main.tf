###################################
# AWS Athena - Main Module
###################################
# WorkGroups
resource "aws_athena_workgroup" "this" {
  for_each = { for wg in var.workgroups : wg.name => wg }

  name        = each.value.name
  description = each.value.description
  state       = each.value.state

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = each.value.enable_cloudwatch

    result_configuration {
      output_location = each.value.output_location != null ? each.value.output_location : (
        var.create_results_bucket ? "s3://${var.bucket_athena}/" : null
      )

      encryption_configuration {
        encryption_option = each.value.encryption_option
      }
    }
  }

  tags = var.tags
}

# Named Queries
resource "aws_athena_named_query" "this" {
  for_each = { for nq in var.named_queries : nq.name => nq }

  name        = each.value.name
  database    = each.value.database
  description = each.value.description
  query       = each.value.query
  workgroup   = each.value.workgroup != null ? each.value.workgroup : null

  depends_on = [
    aws_athena_workgroup.this
  ]
}

resource "awscc_athena_capacity_reservation" "this" {
  for_each = { for cr in var.capacity_reservations : cr.name => cr }

  name        = each.value.name
  target_dpus = each.value.target_dpus
  capacity_assignment_configuration = {
    capacity_assignments = [
      {
        workgroup_names = each.value.workgroup_names
      }
    ]
  }
  tags = [for k, v in var.tags : { key = k, value = v }]
}

# Data Catalogs (Data Sources extras)
resource "aws_athena_data_catalog" "this" {
  for_each = {
    for ds in var.data_sources_catalogs : ds.name => ds
    if ds.type != "GLUE"  # ignora os GLUE, pois já existem
  }

  name        = each.value.name
  description = lookup(each.value, "description", "Data source criado pelo Terraform")
  type        = each.value.type
  parameters  = lookup(each.value, "parameters", {})

  tags = var.tags
}
