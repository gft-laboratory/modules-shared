resource "aws_dms_replication_instance" "this" {
  replication_instance_id     = var.replication_instance_id
  replication_instance_class  = var.replication_instance_class
  replication_subnet_group_id = aws_dms_replication_subnet_group.this.replication_subnet_group_id
  allocated_storage           = var.allocated_storage
  publicly_accessible         = var.publicly_accessible
  vpc_security_group_ids      = var.vpc_security_group_ids
  availability_zone           = var.availability_zone
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  kms_key_arn                 = var.kms_key_arn
  tags                        = var.tags

  depends_on = [ aws_dms_replication_subnet_group.this, aws_iam_role.dms_vpc_role ]
}

resource "aws_dms_replication_subnet_group" "this" {
  replication_subnet_group_id          = var.subnet_group_name_id
  replication_subnet_group_description = var.subnet_group_description
  subnet_ids                           = var.subnet_ids
  tags                                 = var.tags
}

resource "aws_dms_endpoint" "source" {
  endpoint_id        = var.source_endpoint_id
  endpoint_type      = "source"
  engine_name        = var.source_engine_name
  username           = var.source_username
  password           = var.source_password
  server_name        = var.source_server_name
  port               = var.source_port
  database_name      = var.source_database_name
  kms_key_arn        = var.kms_key_arn
  tags               = var.tags
}

resource "aws_dms_endpoint" "target" {
  endpoint_id        = var.target_endpoint_id
  endpoint_type      = "target"
  engine_name        = var.target_engine_name
  username           = var.target_username
  password           = var.target_password
  server_name        = var.target_server_name
  port               = var.target_port
  database_name      = var.target_database_name
  kms_key_arn        = var.kms_key_arn
  tags               = var.tags
}

resource "aws_dms_replication_task" "this" {
  replication_task_id         = var.replication_task_id
  replication_instance_arn    = aws_dms_replication_instance.this.replication_instance_arn
  source_endpoint_arn         = aws_dms_endpoint.source.endpoint_arn
  target_endpoint_arn         = aws_dms_endpoint.target.endpoint_arn
  migration_type              = var.migration_type
  table_mappings              = var.table_mappings
  replication_task_settings   = var.replication_task_settings
  tags                        = var.tags

  depends_on = [ aws_dms_endpoint.source, aws_dms_endpoint.target]
  }

resource "aws_iam_role" "dms_vpc_role" {
  name = "dms-vpc-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "dms.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dms_vpc_role_attach" {
  role       = aws_iam_role.dms_vpc_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"

  depends_on = [ aws_iam_role.dms_vpc_role ]
}
