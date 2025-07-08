# Terraform Module: Security Group

Este módulo cria e gerencia um Security Group (SG) na AWS com suporte completo a regras de ingress e egress altamente configuráveis, incluindo suporte a diferentes fontes como CIDR, IPv6, prefix list, SGs e regras internas (self).

## Funcionalidades

- Criação opcional do Security Group (create_sg)
- Suporte para gerenciamento de regras em um Security Group existente (security_group_id)
- Definição altamente flexível de regras usando:
- Regras nomeadas via o mapa rules
- cidr_blocks, ipv6_cidr_blocks, source_security_group_id, self, e prefix_list_ids
- Suporte separado para regras de Ingress e Egress
- Suporte a tags

---

## Exemplo de uso

```hcl
module "security_group" {
  source = "./modules/security-group"

  name   = "my-sg"
  vpc_id = "vpc-abc123"

  create    = true
  create_sg = true

  ingress_rules = ["http-80-tcp", "https-443-tcp"]
  egress_rules  = ["http-80-tcp"]

  ingress_cidr_blocks = ["10.0.0.0/16"]
  egress_cidr_blocks  = ["0.0.0.0/0"]

  tags = {
    Environment = "dev"
    Project     = "example"
  }
}
```


## Inputs
| Nome                                    | Tipo                | Padrão             | Descrição                                |
| --------------------------------------- | ------------------- | ------------------ | ---------------------------------------- |
| `name`                                  | `string`            | `""`               | Nome do Security Group                   |
| `vpc_id`                                | `string`            | `""`               | ID da VPC onde o SG será criado          |
| `tags`                                  | `map(string)`       | `{}`               | Tags a serem atribuídas ao SG            |
| `create`                                | `bool`              | `true`             | Se deve criar regras e o SG              |
| `create_sg`                             | `bool`              | `true`             | Se deve criar o Security Group           |
| `security_group_id`                     | `string`            | `null`             | ID de SG existente para gerenciar regras |
| `rules`                                 | `map(list(any))`    | Ver `variables.tf` | Mapa de regras nomeadas predefinidas     |
| `ingress_rules`                         | `list(string)`      | `[]`               | Lista de regras nomeadas de ingress      |
| `ingress_with_self`                     | `list(map(string))` | `[]`               | Regras de ingress usando `self`          |
| `ingress_with_cidr_blocks`              | `list(map(string))` | `[]`               | Regras de ingress com CIDR blocks        |
| `ingress_with_ipv6_cidr_blocks`         | `list(map(string))` | `[]`               | Regras de ingress com IPv6 CIDR blocks   |
| `ingress_with_source_security_group_id` | `list(map(string))` | `[]`               | Regras de ingress com source SG ID       |
| `ingress_with_prefix_list_ids`          | `list(map(string))` | `[]`               | Regras de ingress com prefix list IDs    |
| `ingress_cidr_blocks`                   | `list(string)`      | `[]`               | Faixas IPv4 padrão para ingress          |
| `ingress_ipv6_cidr_blocks`              | `list(string)`      | `[]`               | Faixas IPv6 padrão para ingress          |
| `ingress_prefix_list_ids`               | `list(string)`      | `[]`               | Prefix lists padrão para ingress         |
| `egress_rules`                          | `list(string)`      | `[]`               | Lista de regras nomeadas de egress       |
| `egress_with_self`                      | `list(map(string))` | `[]`               | Regras de egress usando `self`           |
| `egress_with_cidr_blocks`               | `list(map(string))` | `[]`               | Regras de egress com CIDR blocks         |
| `egress_with_ipv6_cidr_blocks`          | `list(map(string))` | `[]`               | Regras de egress com IPv6 CIDR blocks    |
| `egress_with_source_security_group_id`  | `list(map(string))` | `[]`               | Regras de egress com source SG ID        |
| `egress_with_prefix_list_ids`           | `list(map(string))` | `[]`               | Regras de egress com prefix list IDs     |
| `egress_cidr_blocks`                    | `list(string)`      | `["0.0.0.0/0"]`    | Faixas IPv4 padrão para egress           |
| `egress_ipv6_cidr_blocks`               | `list(string)`      | `["::/0"]`         | Faixas IPv6 padrão para egress           |
| `egress_prefix_list_ids`                | `list(string)`      | `[]`               | Prefix lists padrão para egress          |


## Outputs
| Nome             | Descrição                            |
| ---------------- | ------------------------------------ |
| `sg_arn`         | ARN do Security Group                |
| `sg_id`          | ID do Security Group                 |
| `sg_name`        | Nome do Security Group               |
| `sg_description` | Descrição do Security Group          |
| `sg_owner_id`    | ID do proprietário do Security Group |
| `sg_vpc_id`      | ID da VPC onde o SG está associado   |



Formato de Regras (variável rules)
Este módulo define um mapa de regras onde é possível usar nomes amigáveis para referenciar protocolos e portas comuns.

Cada entrada de regra deve seguir o seguinte formato:

```hcl
rule_name = [from_port, to_port, protocol, description]
```

Exemplos:

```hcl
ssh-tcp = [22, 22, "tcp", "SSH access"]
http-80-tcp = [80, 80, "tcp", "HTTP"]
custom-app = [8080, 8090, "tcp", "App traffic"]
```

## Notas
* Se create_sg = false mas create = true, apenas as regras serão gerenciadas usando o ID de Security Group existente (security_group_id).

* É possível usar prefix_list_ids, self, cidr_blocks e source_security_group_id de forma independente ou combinada nas definições de regra.

* Use rules para templates de controle de acesso predefinidos e reutilizáveis.


## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.custom_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.egress_with_cidr_blocks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.egress_with_ipv6_cidr_blocks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.egress_with_prefix_list_ids](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.egress_with_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.egress_with_source_security_group_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_with_cidr_blocks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_with_ipv6_cidr_blocks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_with_prefix_list_ids](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_with_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_with_source_security_group_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create) | Whether to create security group and all rules | `bool` | `true` | no |
| <a name="input_create_sg"></a> [create\_sg](#input\_create\_sg) | Whether to create security group | `bool` | `true` | no |
| <a name="input_egress_cidr_blocks"></a> [egress\_cidr\_blocks](#input\_egress\_cidr\_blocks) | List of IPv4 CIDR ranges to use on all egress rules | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_egress_ipv6_cidr_blocks"></a> [egress\_ipv6\_cidr\_blocks](#input\_egress\_ipv6\_cidr\_blocks) | List of IPv6 CIDR ranges to use on all egress rules | `list(string)` | <pre>[<br>  "::/0"<br>]</pre> | no |
| <a name="input_egress_prefix_list_ids"></a> [egress\_prefix\_list\_ids](#input\_egress\_prefix\_list\_ids) | List of prefix list IDs (for allowing access to VPC endpoints) to use on all egress rules | `list(string)` | `[]` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | List of egress rules to create by name | `list(string)` | `[]` | no |
| <a name="input_egress_with_cidr_blocks"></a> [egress\_with\_cidr\_blocks](#input\_egress\_with\_cidr\_blocks) | List of egress rules to create where 'cidr\_blocks' is used | `list(map(string))` | `[]` | no |
| <a name="input_egress_with_ipv6_cidr_blocks"></a> [egress\_with\_ipv6\_cidr\_blocks](#input\_egress\_with\_ipv6\_cidr\_blocks) | List of egress rules to create where 'ipv6\_cidr\_blocks' is used | `list(map(string))` | `[]` | no |
| <a name="input_egress_with_prefix_list_ids"></a> [egress\_with\_prefix\_list\_ids](#input\_egress\_with\_prefix\_list\_ids) | List of egress rules to create where 'prefix\_list\_ids' is used only | `list(map(string))` | `[]` | no |
| <a name="input_egress_with_self"></a> [egress\_with\_self](#input\_egress\_with\_self) | List of egress rules to create where 'self' is defined | `list(map(string))` | `[]` | no |
| <a name="input_egress_with_source_security_group_id"></a> [egress\_with\_source\_security\_group\_id](#input\_egress\_with\_source\_security\_group\_id) | List of egress rules to create where 'source\_security\_group\_id' is used | `list(map(string))` | `[]` | no |
| <a name="input_ingress_cidr_blocks"></a> [ingress\_cidr\_blocks](#input\_ingress\_cidr\_blocks) | List of IPv4 CIDR ranges to use on all ingress rules | `list(string)` | `[]` | no |
| <a name="input_ingress_ipv6_cidr_blocks"></a> [ingress\_ipv6\_cidr\_blocks](#input\_ingress\_ipv6\_cidr\_blocks) | List of IPv6 CIDR ranges to use on all ingress rules | `list(string)` | `[]` | no |
| <a name="input_ingress_prefix_list_ids"></a> [ingress\_prefix\_list\_ids](#input\_ingress\_prefix\_list\_ids) | List of prefix list IDs (for allowing access to VPC endpoints) to use on all ingress rules | `list(string)` | `[]` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | List of ingress rules to create by name | `list(string)` | `[]` | no |
| <a name="input_ingress_with_cidr_blocks"></a> [ingress\_with\_cidr\_blocks](#input\_ingress\_with\_cidr\_blocks) | List of ingress rules to create where 'cidr\_blocks' is used | `list(map(string))` | `[]` | no |
| <a name="input_ingress_with_ipv6_cidr_blocks"></a> [ingress\_with\_ipv6\_cidr\_blocks](#input\_ingress\_with\_ipv6\_cidr\_blocks) | List of ingress rules to create where 'ipv6\_cidr\_blocks' is used | `list(map(string))` | `[]` | no |
| <a name="input_ingress_with_prefix_list_ids"></a> [ingress\_with\_prefix\_list\_ids](#input\_ingress\_with\_prefix\_list\_ids) | List of ingress rules to create where 'prefix\_list\_ids' is used only | `list(map(string))` | `[]` | no |
| <a name="input_ingress_with_self"></a> [ingress\_with\_self](#input\_ingress\_with\_self) | List of ingress rules to create where 'self' is defined | `list(map(string))` | `[]` | no |
| <a name="input_ingress_with_source_security_group_id"></a> [ingress\_with\_source\_security\_group\_id](#input\_ingress\_with\_source\_security\_group\_id) | List of ingress rules to create where 'source\_security\_group\_id' is used | `list(map(string))` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used on EC2 instance created | `string` | `""` | no |
| <a name="input_rules"></a> [rules](#input\_rules) | Map of known security group rules (define as 'name' = ['from port', 'to port', 'protocol', 'description']) | `map(list(any))` | <pre>{<br>  "_": [<br>    "",<br>    "",<br>    ""<br>  ],<br>  "activemq-5671-tcp": [<br>    5671,<br>    5671,<br>    "tcp",<br>    "ActiveMQ AMQP"<br>  ],<br>  "activemq-61614-tcp": [<br>    61614,<br>    61614,<br>    "tcp",<br>    "ActiveMQ STOMP"<br>  ],<br>  "activemq-61617-tcp": [<br>    61617,<br>    61617,<br>    "tcp",<br>    "ActiveMQ OpenWire"<br>  ],<br>  "activemq-61619-tcp": [<br>    61619,<br>    61619,<br>    "tcp",<br>    "ActiveMQ WebSocket"<br>  ],<br>  "activemq-8883-tcp": [<br>    8883,<br>    8883,<br>    "tcp",<br>    "ActiveMQ MQTT"<br>  ],<br>  "alertmanager-9093-tcp": [<br>    9093,<br>    9093,<br>    "tcp",<br>    "Alert Manager"<br>  ],<br>  "alertmanager-9094-tcp": [<br>    9094,<br>    9094,<br>    "tcp",<br>    "Alert Manager Cluster"<br>  ],<br>  "all-all": [<br>    -1,<br>    -1,<br>    "-1",<br>    "All protocols"<br>  ],<br>  "all-icmp": [<br>    -1,<br>    -1,<br>    "icmp",<br>    "All IPV4 ICMP"<br>  ],<br>  "all-ipv6-icmp": [<br>    -1,<br>    -1,<br>    58,<br>    "All IPV6 ICMP"<br>  ],<br>  "all-tcp": [<br>    0,<br>    65535,<br>    "tcp",<br>    "All TCP ports"<br>  ],<br>  "all-udp": [<br>    0,<br>    65535,<br>    "udp",<br>    "All UDP ports"<br>  ],<br>  "carbon-admin-tcp": [<br>    2004,<br>    2004,<br>    "tcp",<br>    "Carbon admin"<br>  ],<br>  "carbon-gui-udp": [<br>    8081,<br>    8081,<br>    "tcp",<br>    "Carbon GUI"<br>  ],<br>  "carbon-line-in-tcp": [<br>    2003,<br>    2003,<br>    "tcp",<br>    "Carbon line-in"<br>  ],<br>  "carbon-line-in-udp": [<br>    2003,<br>    2003,<br>    "udp",<br>    "Carbon line-in"<br>  ],<br>  "carbon-pickle-tcp": [<br>    2013,<br>    2013,<br>    "tcp",<br>    "Carbon pickle"<br>  ],<br>  "carbon-pickle-udp": [<br>    2013,<br>    2013,<br>    "udp",<br>    "Carbon pickle"<br>  ],<br>  "cassandra-clients-tcp": [<br>    9042,<br>    9042,<br>    "tcp",<br>    "Cassandra clients"<br>  ],<br>  "cassandra-jmx-tcp": [<br>    7199,<br>    7199,<br>    "tcp",<br>    "JMX"<br>  ],<br>  "cassandra-thrift-clients-tcp": [<br>    9160,<br>    9160,<br>    "tcp",<br>    "Cassandra Thrift clients"<br>  ],<br>  "consul-dns-tcp": [<br>    8600,<br>    8600,<br>    "tcp",<br>    "Consul DNS"<br>  ],<br>  "consul-dns-udp": [<br>    8600,<br>    8600,<br>    "udp",<br>    "Consul DNS"<br>  ],<br>  "consul-grpc-tcp": [<br>    8502,<br>    8502,<br>    "tcp",<br>    "Consul gRPC"<br>  ],<br>  "consul-grpc-tcp-tls": [<br>    8503,<br>    8503,<br>    "tcp",<br>    "Consul gRPC TLS"<br>  ],<br>  "consul-serf-lan-tcp": [<br>    8301,<br>    8301,<br>    "tcp",<br>    "Serf LAN"<br>  ],<br>  "consul-serf-lan-udp": [<br>    8301,<br>    8301,<br>    "udp",<br>    "Serf LAN"<br>  ],<br>  "consul-serf-wan-tcp": [<br>    8302,<br>    8302,<br>    "tcp",<br>    "Serf WAN"<br>  ],<br>  "consul-serf-wan-udp": [<br>    8302,<br>    8302,<br>    "udp",<br>    "Serf WAN"<br>  ],<br>  "consul-tcp": [<br>    8300,<br>    8300,<br>    "tcp",<br>    "Consul server"<br>  ],<br>  "consul-webui-http-tcp": [<br>    8500,<br>    8500,<br>    "tcp",<br>    "Consul web UI HTTP"<br>  ],<br>  "consul-webui-https-tcp": [<br>    8501,<br>    8501,<br>    "tcp",<br>    "Consul web UI HTTPS"<br>  ],<br>  "dax-cluster-encrypted-tcp": [<br>    9111,<br>    9111,<br>    "tcp",<br>    "DAX Cluster encrypted"<br>  ],<br>  "dax-cluster-unencrypted-tcp": [<br>    8111,<br>    8111,<br>    "tcp",<br>    "DAX Cluster unencrypted"<br>  ],<br>  "dns-tcp": [<br>    53,<br>    53,<br>    "tcp",<br>    "DNS"<br>  ],<br>  "dns-udp": [<br>    53,<br>    53,<br>    "udp",<br>    "DNS"<br>  ],<br>  "docker-swarm-mngmt-tcp": [<br>    2377,<br>    2377,<br>    "tcp",<br>    "Docker Swarm cluster management"<br>  ],<br>  "docker-swarm-node-tcp": [<br>    7946,<br>    7946,<br>    "tcp",<br>    "Docker Swarm node"<br>  ],<br>  "docker-swarm-node-udp": [<br>    7946,<br>    7946,<br>    "udp",<br>    "Docker Swarm node"<br>  ],<br>  "docker-swarm-overlay-udp": [<br>    4789,<br>    4789,<br>    "udp",<br>    "Docker Swarm Overlay Network Traffic"<br>  ],<br>  "elasticsearch-java-tcp": [<br>    9300,<br>    9300,<br>    "tcp",<br>    "Elasticsearch Java interface"<br>  ],<br>  "elasticsearch-rest-tcp": [<br>    9200,<br>    9200,<br>    "tcp",<br>    "Elasticsearch REST interface"<br>  ],<br>  "etcd-client-tcp": [<br>    2379,<br>    2379,<br>    "tcp",<br>    "Etcd Client"<br>  ],<br>  "etcd-peer-tcp": [<br>    2380,<br>    2380,<br>    "tcp",<br>    "Etcd Peer"<br>  ],<br>  "grafana-tcp": [<br>    3000,<br>    3000,<br>    "tcp",<br>    "Grafana Dashboard"<br>  ],<br>  "graphite-2003-tcp": [<br>    2003,<br>    2003,<br>    "tcp",<br>    "Carbon receiver plain text"<br>  ],<br>  "graphite-2004-tcp": [<br>    2004,<br>    2004,<br>    "tcp",<br>    "Carbon receiver pickle"<br>  ],<br>  "graphite-2023-tcp": [<br>    2023,<br>    2023,<br>    "tcp",<br>    "Carbon aggregator plaintext"<br>  ],<br>  "graphite-2024-tcp": [<br>    2024,<br>    2024,<br>    "tcp",<br>    "Carbon aggregator pickle"<br>  ],<br>  "graphite-8080-tcp": [<br>    8080,<br>    8080,<br>    "tcp",<br>    "Graphite gunicorn port"<br>  ],<br>  "graphite-8125-tcp": [<br>    8125,<br>    8125,<br>    "tcp",<br>    "Statsd TCP"<br>  ],<br>  "graphite-8125-udp": [<br>    8125,<br>    8125,<br>    "udp",<br>    "Statsd UDP default"<br>  ],<br>  "graphite-8126-tcp": [<br>    8126,<br>    8126,<br>    "tcp",<br>    "Statsd admin"<br>  ],<br>  "graphite-webui": [<br>    80,<br>    80,<br>    "tcp",<br>    "Graphite admin interface"<br>  ],<br>  "http-80-tcp": [<br>    80,<br>    80,<br>    "tcp",<br>    "HTTP"<br>  ],<br>  "http-8080-tcp": [<br>    8080,<br>    8080,<br>    "tcp",<br>    "HTTP"<br>  ],<br>  "https-443-tcp": [<br>    443,<br>    443,<br>    "tcp",<br>    "HTTPS"<br>  ],<br>  "https-8443-tcp": [<br>    8443,<br>    8443,<br>    "tcp",<br>    "HTTPS"<br>  ],<br>  "ipsec-4500-udp": [<br>    4500,<br>    4500,<br>    "udp",<br>    "IPSEC NAT-T"<br>  ],<br>  "ipsec-500-udp": [<br>    500,<br>    500,<br>    "udp",<br>    "IPSEC ISAKMP"<br>  ],<br>  "kafka-broker-sasl-iam-public-tcp": [<br>    9198,<br>    9198,<br>    "tcp",<br>    "Kafka SASL/IAM Public access control enabled (MSK specific)"<br>  ],<br>  "kafka-broker-sasl-iam-tcp": [<br>    9098,<br>    9098,<br>    "tcp",<br>    "Kafka SASL/IAM access control enabled (MSK specific)"<br>  ],<br>  "kafka-broker-sasl-scram-public-tcp": [<br>    9196,<br>    9196,<br>    "tcp",<br>    "Kafka SASL/SCRAM Public enabled broker (MSK specific)"<br>  ],<br>  "kafka-broker-sasl-scram-tcp": [<br>    9096,<br>    9096,<br>    "tcp",<br>    "Kafka SASL/SCRAM enabled broker (MSK specific)"<br>  ],<br>  "kafka-broker-tcp": [<br>    9092,<br>    9092,<br>    "tcp",<br>    "Kafka PLAINTEXT enable broker 0.8.2+"<br>  ],<br>  "kafka-broker-tls-public-tcp": [<br>    9194,<br>    9194,<br>    "tcp",<br>    "Kafka TLS Public enabled broker 0.8.2+ (MSK specific)"<br>  ],<br>  "kafka-broker-tls-tcp": [<br>    9094,<br>    9094,<br>    "tcp",<br>    "Kafka TLS enabled broker 0.8.2+"<br>  ],<br>  "kafka-jmx-exporter-tcp": [<br>    11001,<br>    11001,<br>    "tcp",<br>    "Kafka JMX Exporter"<br>  ],<br>  "kafka-node-exporter-tcp": [<br>    11002,<br>    11002,<br>    "tcp",<br>    "Kafka Node Exporter"<br>  ],<br>  "kibana-tcp": [<br>    5601,<br>    5601,<br>    "tcp",<br>    "Kibana Web Interface"<br>  ],<br>  "kubernetes-api-tcp": [<br>    6443,<br>    6443,<br>    "tcp",<br>    "Kubernetes API Server"<br>  ],<br>  "ldap-tcp": [<br>    389,<br>    389,<br>    "tcp",<br>    "LDAP"<br>  ],<br>  "ldaps-tcp": [<br>    636,<br>    636,<br>    "tcp",<br>    "LDAPS"<br>  ],<br>  "logstash-tcp": [<br>    5044,<br>    5044,<br>    "tcp",<br>    "Logstash"<br>  ],<br>  "loki-grafana": [<br>    3100,<br>    3100,<br>    "tcp",<br>    "Grafana Loki endpoint"<br>  ],<br>  "loki-grafana-grpc": [<br>    9095,<br>    9095,<br>    "tcp",<br>    "Grafana Loki GRPC"<br>  ],<br>  "memcached-tcp": [<br>    11211,<br>    11211,<br>    "tcp",<br>    "Memcached"<br>  ],<br>  "minio-tcp": [<br>    9000,<br>    9000,<br>    "tcp",<br>    "MinIO"<br>  ],<br>  "mongodb-27017-tcp": [<br>    27017,<br>    27017,<br>    "tcp",<br>    "MongoDB"<br>  ],<br>  "mongodb-27018-tcp": [<br>    27018,<br>    27018,<br>    "tcp",<br>    "MongoDB shard"<br>  ],<br>  "mongodb-27019-tcp": [<br>    27019,<br>    27019,<br>    "tcp",<br>    "MongoDB config server"<br>  ],<br>  "mssql-analytics-tcp": [<br>    2383,<br>    2383,<br>    "tcp",<br>    "MSSQL Analytics"<br>  ],<br>  "mssql-broker-tcp": [<br>    4022,<br>    4022,<br>    "tcp",<br>    "MSSQL Broker"<br>  ],<br>  "mssql-tcp": [<br>    1433,<br>    1433,<br>    "tcp",<br>    "MSSQL Server"<br>  ],<br>  "mssql-udp": [<br>    1434,<br>    1434,<br>    "udp",<br>    "MSSQL Browser"<br>  ],<br>  "mysql-tcp": [<br>    3306,<br>    3306,<br>    "tcp",<br>    "MySQL/Aurora"<br>  ],<br>  "nfs-tcp": [<br>    2049,<br>    2049,<br>    "tcp",<br>    "NFS/EFS"<br>  ],<br>  "nomad-http-tcp": [<br>    4646,<br>    4646,<br>    "tcp",<br>    "Nomad HTTP"<br>  ],<br>  "nomad-rpc-tcp": [<br>    4647,<br>    4647,<br>    "tcp",<br>    "Nomad RPC"<br>  ],<br>  "nomad-serf-tcp": [<br>    4648,<br>    4648,<br>    "tcp",<br>    "Serf"<br>  ],<br>  "nomad-serf-udp": [<br>    4648,<br>    4648,<br>    "udp",<br>    "Serf"<br>  ],<br>  "ntp-udp": [<br>    123,<br>    123,<br>    "udp",<br>    "NTP"<br>  ],<br>  "octopus-tentacle-tcp": [<br>    10933,<br>    10933,<br>    "tcp",<br>    "Octopus Tentacle"<br>  ],<br>  "openvpn-https-tcp": [<br>    443,<br>    443,<br>    "tcp",<br>    "OpenVPN"<br>  ],<br>  "openvpn-tcp": [<br>    943,<br>    943,<br>    "tcp",<br>    "OpenVPN"<br>  ],<br>  "openvpn-udp": [<br>    1194,<br>    1194,<br>    "udp",<br>    "OpenVPN"<br>  ],<br>  "oracle-db-tcp": [<br>    1521,<br>    1521,<br>    "tcp",<br>    "Oracle"<br>  ],<br>  "postgresql-tcp": [<br>    5432,<br>    5432,<br>    "tcp",<br>    "PostgreSQL"<br>  ],<br>  "prometheus-http-tcp": [<br>    9090,<br>    9090,<br>    "tcp",<br>    "Prometheus"<br>  ],<br>  "prometheus-node-exporter-http-tcp": [<br>    9100,<br>    9100,<br>    "tcp",<br>    "Prometheus Node Exporter"<br>  ],<br>  "prometheus-pushgateway-http-tcp": [<br>    9091,<br>    9091,<br>    "tcp",<br>    "Prometheus Pushgateway"<br>  ],<br>  "promtail-http": [<br>    9080,<br>    9080,<br>    "tcp",<br>    "Promtail endpoint"<br>  ],<br>  "puppet-tcp": [<br>    8140,<br>    8140,<br>    "tcp",<br>    "Puppet"<br>  ],<br>  "puppetdb-tcp": [<br>    8081,<br>    8081,<br>    "tcp",<br>    "PuppetDB"<br>  ],<br>  "rabbitmq-15672-tcp": [<br>    15672,<br>    15672,<br>    "tcp",<br>    "RabbitMQ"<br>  ],<br>  "rabbitmq-25672-tcp": [<br>    25672,<br>    25672,<br>    "tcp",<br>    "RabbitMQ"<br>  ],<br>  "rabbitmq-4369-tcp": [<br>    4369,<br>    4369,<br>    "tcp",<br>    "RabbitMQ epmd"<br>  ],<br>  "rabbitmq-5671-tcp": [<br>    5671,<br>    5671,<br>    "tcp",<br>    "RabbitMQ"<br>  ],<br>  "rabbitmq-5672-tcp": [<br>    5672,<br>    5672,<br>    "tcp",<br>    "RabbitMQ"<br>  ],<br>  "rdp-tcp": [<br>    3389,<br>    3389,<br>    "tcp",<br>    "Remote Desktop"<br>  ],<br>  "rdp-udp": [<br>    3389,<br>    3389,<br>    "udp",<br>    "Remote Desktop"<br>  ],<br>  "redis-tcp": [<br>    6379,<br>    6379,<br>    "tcp",<br>    "Redis"<br>  ],<br>  "redshift-tcp": [<br>    5439,<br>    5439,<br>    "tcp",<br>    "Redshift"<br>  ],<br>  "saltstack-tcp": [<br>    4505,<br>    4506,<br>    "tcp",<br>    "SaltStack"<br>  ],<br>  "smtp-submission-2587-tcp": [<br>    2587,<br>    2587,<br>    "tcp",<br>    "SMTP Submission"<br>  ],<br>  "smtp-submission-587-tcp": [<br>    587,<br>    587,<br>    "tcp",<br>    "SMTP Submission"<br>  ],<br>  "smtp-tcp": [<br>    25,<br>    25,<br>    "tcp",<br>    "SMTP"<br>  ],<br>  "smtps-2456-tcp": [<br>    2465,<br>    2465,<br>    "tcp",<br>    "SMTPS"<br>  ],<br>  "smtps-465-tcp": [<br>    465,<br>    465,<br>    "tcp",<br>    "SMTPS"<br>  ],<br>  "solr-tcp": [<br>    8983,<br>    8987,<br>    "tcp",<br>    "Solr"<br>  ],<br>  "splunk-hec-tcp": [<br>    8088,<br>    8088,<br>    "tcp",<br>    "Splunk HEC"<br>  ],<br>  "splunk-indexer-tcp": [<br>    9997,<br>    9997,<br>    "tcp",<br>    "Splunk indexer"<br>  ],<br>  "splunk-splunkd-tcp": [<br>    8089,<br>    8089,<br>    "tcp",<br>    "Splunkd"<br>  ],<br>  "splunk-web-tcp": [<br>    8000,<br>    8000,<br>    "tcp",<br>    "Splunk Web"<br>  ],<br>  "squid-proxy-tcp": [<br>    3128,<br>    3128,<br>    "tcp",<br>    "Squid default proxy"<br>  ],<br>  "ssh-tcp": [<br>    22,<br>    22,<br>    "tcp",<br>    "SSH"<br>  ],<br>  "storm-nimbus-tcp": [<br>    6627,<br>    6627,<br>    "tcp",<br>    "Nimbus"<br>  ],<br>  "storm-supervisor-tcp": [<br>    6700,<br>    6703,<br>    "tcp",<br>    "Supervisor"<br>  ],<br>  "storm-ui-tcp": [<br>    8080,<br>    8080,<br>    "tcp",<br>    "Storm UI"<br>  ],<br>  "vault-tcp": [<br>    8200,<br>    8200,<br>    "tcp",<br>    "Vault"<br>  ],<br>  "wazuh-dashboard": [<br>    443,<br>    443,<br>    "tcp",<br>    "Wazuh web user interface"<br>  ],<br>  "wazuh-indexer-restful-api": [<br>    9200,<br>    9200,<br>    "tcp",<br>    "Wazuh indexer RESTful API"<br>  ],<br>  "wazuh-server-agent-cluster-daemon": [<br>    1516,<br>    1516,<br>    "tcp",<br>    "Wazuh cluster daemon"<br>  ],<br>  "wazuh-server-agent-connection-tcp": [<br>    1514,<br>    1514,<br>    "tcp",<br>    "Agent connection service(TCP)"<br>  ],<br>  "wazuh-server-agent-connection-udp": [<br>    1514,<br>    1514,<br>    "udp",<br>    "Agent connection service(UDP)"<br>  ],<br>  "wazuh-server-agent-enrollment": [<br>    1515,<br>    1515,<br>    "tcp",<br>    "Agent enrollment service"<br>  ],<br>  "wazuh-server-restful-api": [<br>    55000,<br>    55000,<br>    "tcp",<br>    "Wazuh server RESTful API"<br>  ],<br>  "wazuh-server-syslog-collector-tcp": [<br>    514,<br>    514,<br>    "tcp",<br>    "Wazuh Syslog collector(TCP)"<br>  ],<br>  "wazuh-server-syslog-collector-udp": [<br>    514,<br>    514,<br>    "udp",<br>    "Wazuh Syslog collector(UDP)"<br>  ],<br>  "web-jmx-tcp": [<br>    1099,<br>    1099,<br>    "tcp",<br>    "JMX"<br>  ],<br>  "winrm-http-tcp": [<br>    5985,<br>    5985,<br>    "tcp",<br>    "WinRM HTTP"<br>  ],<br>  "winrm-https-tcp": [<br>    5986,<br>    5986,<br>    "tcp",<br>    "WinRM HTTPS"<br>  ],<br>  "zabbix-agent": [<br>    10050,<br>    10050,<br>    "tcp",<br>    "Zabbix Agent"<br>  ],<br>  "zabbix-proxy": [<br>    10051,<br>    10051,<br>    "tcp",<br>    "Zabbix Proxy"<br>  ],<br>  "zabbix-server": [<br>    10051,<br>    10051,<br>    "tcp",<br>    "Zabbix Server"<br>  ],<br>  "zipkin-admin-query-tcp": [<br>    9901,<br>    9901,<br>    "tcp",<br>    "Zipkin Admin port query"<br>  ],<br>  "zipkin-admin-tcp": [<br>    9990,<br>    9990,<br>    "tcp",<br>    "Zipkin Admin port collector"<br>  ],<br>  "zipkin-admin-web-tcp": [<br>    9991,<br>    9991,<br>    "tcp",<br>    "Zipkin Admin port web"<br>  ],<br>  "zipkin-query-tcp": [<br>    9411,<br>    9411,<br>    "tcp",<br>    "Zipkin query port"<br>  ],<br>  "zipkin-web-tcp": [<br>    8080,<br>    8080,<br>    "tcp",<br>    "Zipkin web port"<br>  ],<br>  "zookeeper-2181-tcp": [<br>    2181,<br>    2181,<br>    "tcp",<br>    "Zookeeper"<br>  ],<br>  "zookeeper-2182-tls-tcp": [<br>    2182,<br>    2182,<br>    "tcp",<br>    "Zookeeper TLS (MSK specific)"<br>  ],<br>  "zookeeper-2888-tcp": [<br>    2888,<br>    2888,<br>    "tcp",<br>    "Zookeeper"<br>  ],<br>  "zookeeper-3888-tcp": [<br>    3888,<br>    3888,<br>    "tcp",<br>    "Zookeeper"<br>  ],<br>  "zookeeper-jmx-tcp": [<br>    7199,<br>    7199,<br>    "tcp",<br>    "JMX"<br>  ]<br>}</pre> | no |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | ID of existing security group whose rules we will manage | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Vpc Id used to create SG | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sg_arn"></a> [sg\_arn](#output\_sg\_arn) | The ARN of the security group |
| <a name="output_sg_description"></a> [sg\_description](#output\_sg\_description) | The description of the security group |
| <a name="output_sg_id"></a> [sg\_id](#output\_sg\_id) | The ID of the security group |
| <a name="output_sg_name"></a> [sg\_name](#output\_sg\_name) | The name of the security group |
| <a name="output_sg_owner_id"></a> [sg\_owner\_id](#output\_sg\_owner\_id) | The owner ID |
| <a name="output_sg_vpc_id"></a> [sg\_vpc\_id](#output\_sg\_vpc\_id) | The VPC ID |
