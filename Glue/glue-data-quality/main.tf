resource "aws_glue_data_quality_ruleset" "this" {
  name            = var.name
  description     = var.description
  ruleset         = var.ruleset
  target_table {
    database_name = var.database_name
    table_name    = var.table_name
  }
  tags = var.tags
}

resource "aws_glue_data_quality_ruleset_evaluation_run" "this" {
  count = var.enable_evaluation_run ? 1 : 0

  data_quality_ruleset_name = aws_glue_data_quality_ruleset.this.name
}
