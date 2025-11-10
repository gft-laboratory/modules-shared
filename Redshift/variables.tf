#####################################
# Variáveis principais
#####################################

variable "mode" {
  type        = string
  description = "Modo de criação do Redshift. Use 'provisioned' para criar um Cluster clássico ou 'serverless' para criar Namespace/Workgroup Serverless."
  default     = "serverless"
  validation {
    condition     = contains(["provisioned", "serverless"], var.mode)
    error_message = "mode deve ser 'provisioned' ou 'serverless'."
  }
}

variable "region" {
  type        = string
  description = "Região AWS onde os recursos serão criados (ex.: sa-east-1)."
  default     = null
}

variable "project" {
  type        = string
  description = "Nome do projeto para composição de tags e identificação."
  default     = "data-platform"
}

variable "environment" {
  type        = string
  description = "Ambiente (ex.: dev, hml, prd) para composição de tags e identificação."
  default     = "dev"
}

variable "managed_by" {
  type        = string
  description = "Identificador do gerenciador do recurso, por padrão 'terraform'."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Mapa de tags adicionais aplicadas a todos os recursos."
  default     = {}
}

#####################################
# Rede e Segurança
#####################################

variable "vpc_id" {
  type        = string
  description = "ID da VPC onde o Redshift operará. Necessário se create_security_group = true ou para fornecer security groups existentes."
  default     = null
}

variable "subnet_ids" {
  type        = list(string)
  description = "Lista de Subnets privadas para o Redshift (obrigatório para Serverless e para Cluster Provisioned com Subnet Group)."
  default     = []
}

variable "sg_ingress_rules" {
  type = list(object({
    description      = optional(string)
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    security_groups  = optional(list(string))
  }))
  description = "Regras de entrada para o Security Group criado pelo módulo."
  default     = []
}

variable "sg_egress_rules" {
  type = list(object({
    description      = optional(string)
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    security_groups  = optional(list(string))
  }))
  description = "Regras de saída para o Security Group criado pelo módulo."
  default     = []
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "Lista de Security Groups já existentes a serem associados ao Cluster/Workgroup."
  default     = []
}

#####################################
# Configurações comuns
#####################################

variable "database_name" {
  type        = string
  description = "Nome do banco de dados padrão a ser criado (em Cluster ou Serverless)."
  default     = "dev"
}

variable "port" {
  type        = number
  description = "Porta de conexão do Redshift (padrão 5439)."
  default     = 5439
}

variable "publicly_accessible" {
  type        = bool
  description = "Define se o endpoint do Redshift será público (NÃO recomendado para produção)."
  default     = false
}

variable "enhanced_vpc_routing" {
  type        = bool
  description = "Se true, ativa Enhanced VPC Routing para redirecionar tráfego COPY/UNLOAD pela VPC."
  default     = true
}

variable "iam_role_arns" {
  type        = list(string)
  description = "Lista de ARNs de IAM Roles associadas (ex.: acesso ao S3 para COPY/UNLOAD, Spectrum, etc.)."
  default     = []
}

variable "kms_key_id" {
  type        = string
  description = "KMS Key para criptografia em repouso (Cluster ou Namespace)."
  default     = null
}

variable "encrypted" {
  type        = bool
  description = "Se true, habilita criptografia do Cluster Provisioned (em Serverless, use kms_key_id)."
  default     = true
}

#####################################
# Provisioned: Subnet/Parameter Group
#####################################

variable "create_subnet_group" {
  type        = bool
  description = "Se true, cria um Redshift Subnet Group. Caso false, informe existing_subnet_group_name."
  default     = true
}

variable "subnet_group_name" {
  type        = string
  description = "Nome do Redshift Subnet Group quando create_subnet_group = true."
  default     = null
}

variable "existing_subnet_group_name" {
  type        = string
  description = "Nome de um Subnet Group existente (use quando create_subnet_group = false)."
  default     = null
}

variable "create_parameter_group" {
  type        = bool
  description = "Se true, cria um Redshift Parameter Group personalizado."
  default     = false
}

variable "parameter_group_name" {
  type        = string
  description = "Nome do Parameter Group quando create_parameter_group = true."
  default     = null
}

variable "parameter_group_family" {
  type        = string
  description = "Família do Parameter Group (ex.: redshift-1.0, redshift-1.0:dc2, etc.)."
  default     = "redshift-1.0"
}

variable "parameter_overrides" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "Lista de parâmetros personalizados para o Parameter Group (nome/valor)."
  default     = []
}

#####################################
# Provisioned: Cluster
#####################################

variable "cluster_identifier" {
  type        = string
  description = "Identificador único do Cluster Redshift (apenas modo provisioned)."
  default     = null
}

variable "node_type" {
  type        = string
  description = "Tipo de nó do Cluster (ex.: ra3.xlplus, ra3.4xlarge, dc2.large)."
  default     = "ra3.xlplus"
}

variable "number_of_nodes" {
  type        = number
  description = "Número de nós do Cluster (>=1). Para single-node, usar 1."
  default     = 2
}

variable "master_username" {
  type        = string
  description = "Usuário administrador do Cluster (provisioned)."
  default     = "admin"
}

variable "master_password" {
  type        = string
  description = "Senha do usuário administrador do Cluster (provisioned). Use mecanismos seguros (ex.: Terraform Cloud/Secrets Manager)."
  sensitive   = true
  default     = null
}

variable "allow_version_upgrade" {
  type        = bool
  description = "Se true, permite atualizações automáticas de versão do Redshift."
  default     = true
}

variable "automated_snapshot_retention_period" {
  type        = number
  description = "Período de retenção (dias) dos snapshots automáticos do Cluster."
  default     = 7
}

variable "maintenance_window" {
  type        = string
  description = "Janela de manutenção (LEGADO). Prefira preferred_maintenance_window."
  default     = null
}

variable "preferred_maintenance_window" {
  type        = string
  description = "Janela de manutenção preferencial no formato ddd:hh24:mi-ddd:hh24:mi (ex.: Sun:23:00-Mon:01:30)."
  default     = null
}

# Logging (Cluster)
variable "enable_logging" {
  type        = bool
  description = "Se true, habilita logging do Cluster em um bucket S3."
  default     = false
}

variable "logging_bucket" {
  type        = string
  description = "Nome do bucket S3 para logs do Cluster (quando enable_logging = true)."
  default     = null
}

variable "logging_s3_key_prefix" {
  type        = string
  description = "Prefixo (pasta) no bucket S3 para armazenar os logs do Cluster."
  default     = null
}

#####################################
# Serverless: Namespace & Workgroup
#####################################

variable "namespace_name" {
  type        = string
  description = "Nome do Namespace para Redshift Serverless."
  default     = null
}

variable "admin_username" {
  type        = string
  description = "Usuário administrador do Namespace Serverless."
  default     = "admin"
}

variable "admin_user_password" {
  type        = string
  description = "Senha do usuário administrador do Namespace Serverless. Armazene de forma segura."
  sensitive   = true
  default     = null
}

variable "default_iam_role_arn" {
  type        = string
  description = "IAM Role padrão do Namespace Serverless (opcional)."
  default     = null
}

variable "serverless_log_exports" {
  type        = list(string)
  description = "Lista de logs a exportar no Serverless (ex.: userlog, connectionlog, useractivitylog)."
  default     = []
}

variable "workgroup_name" {
  type        = string
  description = "Nome do Workgroup do Redshift Serverless."
  default     = null
}

variable "base_capacity" {
  type        = number
  description = "Capacidade base (RPUs) para o Workgroup Serverless."
  default     = 8
}

variable "serverless_config_parameters" {
  type = list(object({
    parameter_key   = string
    parameter_value = string
  }))
  description = "Parâmetros específicos do Workgroup (pares chave/valor)."
  default     = []
}

variable "existing_parameter_group_name" {
  description = "Nome de um Redshift Parameter Group existente que será reutilizado. Se não informado, será criado um novo."
  type        = string
  default     = null
}
