# Módulo Terraform - AWS DMS (Database Migration Service)

Este módulo provisiona os principais recursos do AWS DMS (Database Migration Service), usado para migração de dados entre bancos de dados de forma segura e gerenciada. Ele contempla:

- Instância de replicação
- Grupo de sub-redes
- Endpoints (source e target)
- Tarefa de replicação

### 🔧 Utilização

```hcl
module "dms" {
  source = "git::ssh://git@github.com/aws-sagemaker-project/module-shared-lake.git//modules/DMS?ref=v0.1.1"

  replication_instance_id       = "dms-repl-instance"
  replication_instance_class    = "dms.t3.medium"
  allocated_storage             = 100
  publicly_accessible           = false
  vpc_security_group_ids        = ["sg-123456"]
  availability_zone             = "us-east-2a"
  replication_subnet_group_id   = "dms-subnet-group"
  subnet_group_id               = "dms-subnet-group"
  subnet_group_description      = "DMS subnet group"
  subnet_ids                    = ["subnet-123", "subnet-456"]

  source_endpoint_id            = "source-endpoint"
  source_engine_name            = "mysql"
  source_username               = "user"
  source_password               = "password"
  source_server_name            = "source.db.example"
  source_port                   = 3306
  source_database_name          = "source_db"

  target_endpoint_id            = "target-endpoint"
  target_engine_name            = "postgres"
  target_username               = "user"
  target_password               = "password"
  target_server_name            = "target.db.example"
  target_port                   = 5432
  target_database_name          = "target_db"

  replication_task_id           = "dms-task"
  migration_type                = "full-load"
  table_mappings                = file("./dms/table-mappings.json")
  replication_task_settings     = file("./dms/task-settings.json")

  tags = {
    Environment = "dev"
    Project     = "datalake"
  }
}
```

### 📤 Outputs

| Output                   | Descrição                                       |
|--------------------------|--------------------------------------------------|
| `replication_instance_arn` | ARN da instância de replicação                  |
| `source_endpoint_arn`      | ARN do endpoint de origem                       |
| `target_endpoint_arn`      | ARN do endpoint de destino                      |
| `replication_task_arn`     | ARN da tarefa de replicação                    |
