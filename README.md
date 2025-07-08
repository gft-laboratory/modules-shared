# Terraform Module Shared Lake

Welcome to our Terraform module guide for deploying infrastructure as code composed of services like Simple Storage Service (S3), DynamoDB, SageMaker Studio, DataZone, Glue, KMS, DMS, Redshift, Secrets Manager, Lake Formation, Lambda, Apache Airflow, and now RDS with Aurora Global on AWS Cloud.

The purpose of the Application Resource solution is to provide a unified set of AWS services to build applications in a simple and consistent way.

We've divided the code into distinct modules for better navigation and customization.

## Modules include:

- `DMS`: Sub-module responsible for provisioning replication instances, source and target endpoints, and migration tasks using AWS Database Migration Service.
- `DynamoDB`: Sub-module for creating non-relational tables used by the application.
- `Glue`: Sub-module responsible for provisioning AWS Glue resources such as databases, tables, jobs, connections, and triggers for data cataloging and ETL processing.
- `IAM-Policy`: Sub-module for creating and optionally attaching custom or managed IAM policies to existing roles.
- `IAM-Role`: Sub-module for creating IAM roles with custom trust policies, used by services like Lambda, Glue, and others.
- `KMS`: Sub-module for creating and managing AWS KMS keys for encrypting data across services like S3, DynamoDB, Secrets Manager, and more.
- `Lambda`: Sub-module responsible for provisioning AWS Lambda functions, including runtime, handler, environment variables, and permissions.
- `RDS-AuroraGlobal`: Sub-module to provision Amazon Aurora Global Database clusters, supporting cross-region replication and high availability for PostgreSQL workloads.
- `S3`: Sub-module for creating private buckets to store application-related objects.
- `SecretsManager`: Sub-module for securely storing sensitive values such as credentials, tokens, and secrets using AWS Secrets Manager.
- `SecurityGroup`: Sub-module for creating customized Security Groups with configurable ingress and egress rules.

> **Note**: This guide and the corresponding modules are continuously being improved and extended.

## Usage

Variables/locals are values used multiple times across different parts of the code. It is recommended to declare them at the top of your Terraform files. Example usage:

```hcl
module "glue" {
  source             = "./modules/glue"
  create_glue_job    = true
  glue_jobs          = local.glue_jobs
  create_glue_table  = true
  glue_tables        = local.glue_tables
  iam_role_glue_arn  = module.iam_roles.glue_role_arn
  tags               = local.default_tags
}

module "rds_aurora_global" {
  source              = "./modules/rds_aurora_global"
  engine              = "aurora-postgresql"
  engine_version      = "15.3"
  region_secondary    = "us-east-1"
  vpc_id              = local.vpc_id
  db_subnet_group     = local.db_subnet_group
  kms_key_id          = module.kms.aurora_key_id
  instance_class      = "db.r6g.large"
  cluster_parameters  = local.aurora_cluster_parameters
  tags                = local.default_tags
}
```
For detailed examples, refer to each module's README.md inside the modules/ directory.