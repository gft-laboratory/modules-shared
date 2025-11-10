variable "projeto" {
  description = "Nome do projeto ao qual o domínio pertence"
  type        = string
}

variable "ambiente" {
  description = "Ambiente (ex: dev, hml, prd)"
  type        = string
}

variable "domain_name" {
  description = "Nome do domínio OpenSearch"
  type        = string
}

variable "engine_version" {
  description = "Versão do OpenSearch a ser utilizada (ex: OpenSearch_2.11)"
  type        = string
  default     = "OpenSearch_2.11"
}

variable "instance_type" {
  description = "Tipo de instância EC2 usada pelos nós do cluster"
  type        = string
  default     = "t3.small.search"
}

variable "instance_count" {
  description = "Quantidade de instâncias no cluster"
  type        = number
  default     = 2
}

variable "dedicated_master_enabled" {
  description = "Se true, ativa nós mestres dedicados"
  type        = bool
  default     = false
}

variable "dedicated_master_type" {
  description = "Tipo de instância dos nós mestres dedicados"
  type        = string
  default     = "t3.small.search"
}

variable "dedicated_master_count" {
  description = "Quantidade de nós mestres dedicados"
  type        = number
  default     = 3
}

variable "zone_awareness_enabled" {
  description = "Habilita alta disponibilidade entre zonas"
  type        = bool
  default     = true
}

variable "availability_zone_count" {
  description = "Número de zonas de disponibilidade usadas"
  type        = number
  default     = 2
}

variable "ebs_enabled" {
  description = "Define se o armazenamento EBS será utilizado"
  type        = bool
  default     = true
}

variable "ebs_volume_size" {
  description = "Tamanho do volume EBS em GB"
  type        = number
  default     = 20
}

variable "ebs_volume_type" {
  description = "Tipo do volume EBS (gp3, io1, etc)"
  type        = string
  default     = "gp3"
}

variable "ebs_iops" {
  description = "IOPS para volume io1 (caso aplicável)"
  type        = number
  default     = null
}

variable "kms_key_id" {
  description = "ID da chave KMS usada para criptografia em repouso"
  type        = string
  default     = null
}

variable "tls_security_policy" {
  description = "Política TLS (ex: Policy-Min-TLS-1-2-2019-07)"
  type        = string
  default     = "Policy-Min-TLS-1-2-2019-07"
}

variable "custom_endpoint_enabled" {
  description = "Define se será usado um endpoint customizado"
  type        = bool
  default     = false
}

variable "custom_endpoint" {
  description = "Endpoint customizado (ex: search.exemplo.com)"
  type        = string
  default     = null
}

variable "custom_endpoint_certificate_arn" {
  description = "ARN do certificado ACM para o endpoint customizado"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "Lista de subnets privadas associadas ao domínio"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Lista de security groups associados ao domínio"
  type        = list(string)
}

variable "access_policies" {
  description = "Políticas de acesso JSON para o OpenSearch"
  type        = string
}

variable "advanced_options" {
  description = "Configurações avançadas do OpenSearch"
  type        = map(string)
  default     = {}
}

variable "encrypt_at_rest_enabled" {
  description = "Ativa ou desativa criptografia em repouso"
  type        = bool
  default     = true
}

variable "node_to_node_encryption_enabled" {
  description = "Ativa ou desativa criptografia entre nós do cluster"
  type        = bool
  default     = true
}

variable "snapshot_start_hour" {
  description = "Hora de início do snapshot automatizado (UTC). Se null, snapshot não será configurado."
  type        = number
  default     = null
}

variable "cloudwatch_log_group_arn" {
  description = "ARN do log group do CloudWatch onde logs serão enviados"
  type        = string
  default     = null
}

variable "log_retention_days" {
  description = "Tempo de retenção dos logs em dias. Se null, não cria log group."
  type        = number
  default     = null
}

variable "tags" {
  description = "Tags adicionais para os recursos"
  type        = map(string)
  default     = {}
}
