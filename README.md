# Terraform Module Shared Lake

Welcome to our Terraform module guide for deploying infrastructure as code composed of services like Simple Storage Service (S3), DynamoDB, SageMaker Studio, DataZone, Glue, KMS, DMS, Redshift, Secrets Manager, Lake Formation, Lambda, Apache Airflow, and now RDS with Aurora Global on AWS Cloud.

The purpose of the Application Resource solution is to provide a unified set of AWS services to build applications in a simple and consistent way.

We've divided the code into distinct modules for better navigation and customization.

## Modules include:

- `Athena`: Sub-module responsible for creating and configuring AWS Athena workgroups, queries, and result locations for analytical queries over data stored in S3.
- `DMS`: Sub-module responsible for provisioning replication instances, source and target endpoints, and migration tasks using AWS Database Migration Service.
- `DataZone`: Sub-module that automates the provisioning of AWS DataZone resources to enable secure data sharing, cataloging, and governance across data producers and consumers.
- `DynamoDB`: Sub-module for creating and configuring non-relational DynamoDB tables, including provisioned or on-demand capacity modes, encryption, and TTL management.
- `EventBridge`: Sub-module to provision AWS EventBridge resources such as event buses, rules, and targets, enabling decoupled, event-driven architectures.
- `Glue`: Sub-module for provisioning AWS Glue resources — databases, tables, crawlers, jobs, and triggers — used for data cataloging, transformation, and ETL pipelines.
- `IAM-Policy`: Sub-module for creating and optionally attaching custom or managed IAM policies to existing IAM roles or services. Supports dynamic JSON policy templates and variable interpolation.
- `IAM-Roles`: Sub-module to create IAM roles with trust relationships and custom inline policies, supporting services such as Lambda, Glue, SageMaker, ECS, and others.
- `KMS`: Sub-module for provisioning and managing AWS KMS keys used for encrypting data across services like S3, DynamoDB, Secrets Manager, EBS, and RDS.
- `LakeFormation`: Sub-module responsible for configuring AWS Lake Formation permissions, data locations, and governance controls for centralized data access management across AWS analytics services.
- `Lambda`: Sub-module for provisioning AWS Lambda functions, including runtime configuration, environment variables, permissions, logging, and optional VPC integration.
- `OpenSearchService`: Sub-module to deploy and manage Amazon OpenSearch Service (Elasticsearch) domains, including cluster configuration, fine-grained access control, and CloudWatch integration.
- `RDS-AuroraGlobal`: Sub-module to provision Amazon Aurora Global Database clusters, supporting cross-region replication, high availability, and scalability for PostgreSQL workloads.
- `Redshift`: Sub-module for provisioning Amazon Redshift clusters and related resources for large-scale data warehousing and analytical workloads.
- `S3`: Sub-module for creating Amazon S3 buckets with configurable ACLs, versioning, encryption, lifecycle policies, and logging for application and data storage.
- `SNS`: Sub-module to provision SNS topics and subscriptions, allowing services to communicate via push notifications, email, or Lambda triggers.
- `SecretsManager`: Sub-module for securely storing and managing sensitive information such as credentials, tokens, and API keys using AWS Secrets Manager.
- `SecurityGroup`: Sub-module for creating and managing customized Security Groups with flexible ingress and egress rules for EC2, RDS, Lambda, or other services.
- `StepFunctions`: Sub-module to define AWS Step Functions state machines for orchestrating workflows and coordinating multiple AWS services in sequence.
- `VPCEndpoints`: Sub-module for provisioning VPC Endpoints (Gateway and Interface types), enabling private connectivity between your VPC and AWS services without traversing the public internet.

---

## Design Principles

- **Modularity:** Each service can be provisioned independently or combined with others.  
- **Reusability:** Parameters are abstracted to promote code reuse across environments (dev, stg, prod).  
- **Security:** All modules follow AWS best practices, including encryption, least privilege, and isolation.  
- **Observability:** Integrations with CloudWatch Logs and metrics are supported where applicable.  
- **Scalability:** Designed to scale with your application and infrastructure needs.  

---

## Notes

> This repository and its modules are continuously being updated and extended to support new AWS services, best practices, and DevOps patterns.

> Contributions and improvements are welcome! Please ensure you follow the repository guidelines and versioning conventions before submitting changes.

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