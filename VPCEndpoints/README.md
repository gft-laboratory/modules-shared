# Módulo Terraform — VPC Endpoints

## 📌 Objetivo

Este módulo tem como objetivo provisionar **VPC Endpoints** na AWS de forma flexível e escalável. Ele suporta tanto **Interface Endpoints** (para serviços como S3, DynamoDB, etc) quanto **Gateway Endpoints**, com suporte à criação múltipla via `for_each`.

## ✅ Recursos Suportados

- Interface VPC Endpoint
- Gateway VPC Endpoint
- Private DNS opcional
- Múltiplas subnets ou route tables
- Policies customizadas
- Security Groups (para Interface)
- Tags customizadas e padrão

## 🛠️ Como usar

```hcl
module "vpc_endpoints" {
  source  = "git::ssh://git@github.com/SEU_ORG/SEU_REPO.git//modules/vpc-endpoints?ref=v1.0.0"

  vpc_id = "vpc-12345678"

  default_tags = {
    Owner = "Leonardo"
    Environment = "dev"
  }

  endpoints = {
    s3_gateway = {
      service_name      = "com.amazonaws.us-east-1.s3"
      vpc_endpoint_type = "Gateway"
      route_table_ids   = ["rtb-abcdef12"]
    }

    dynamodb_gateway = {
      service_name      = "com.amazonaws.us-east-1.dynamodb"
      vpc_endpoint_type = "Gateway"
      route_table_ids   = ["rtb-abcdef12"]
    }

    ec2_interface = {
      service_name        = "com.amazonaws.us-east-1.ec2"
      vpc_endpoint_type   = "Interface"
      subnet_ids          = ["subnet-abc", "subnet-def"]
      security_group_ids  = ["sg-12345678"]
      private_dns_enabled = true
      tags = {
        Name = "EC2 Interface Endpoint"
      }
    }
  }
}
```

# Outputs
| Nome                                 | Descrição                             |
| ------------------------------------ | ------------------------------------- |
| `vpc_endpoint_ids`                   | IDs dos endpoints criados             |
| `vpc_endpoint_dns_entries`           | DNS entries dos endpoints (Interface) |
| `vpc_endpoint_network_interface_ids` | Network interfaces (Interface only)   |
| `vpc_endpoint_arns`                  | ARNs dos endpoints                    |


# Requisitos
* Terraform >= 1.3
* AWS Provider >= 5.0