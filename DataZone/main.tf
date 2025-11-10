# ------------------------------------------------------------------------------
# RECURSOS DO DATAZONE
# ------------------------------------------------------------------------------

# 1. Cria o Domínio, que é o container principal para todos os outros recursos.
resource "aws_datazone_domain" "main" {
  name                  = var.domain_name
  domain_execution_role = var.domain_execution_role
  tags                  = var.tags
}

# 2. Cria um Projeto dentro do Domínio. Projetos organizam usuários, dados e ferramentas.
resource "aws_datazone_project" "main" {
  domain_identifier = aws_datazone_domain.main.id
  name              = var.project_name
  description       = var.project_description

  depends_on = [ aws_datazone_domain.main ]
}

# 3. Adiciona um perfil de usuário ao domínio, associando um usuário IAM ou SSO.
resource "aws_datazone_user_profile" "main" {
  # Cria um perfil para cada usuário fornecido na variável.
  for_each = { for user in var.users : user.identifier => user }

  domain_identifier = aws_datazone_domain.main.id
  user_identifier   = each.value.identifier
  user_type         = each.value.type

  depends_on = [ aws_datazone_domain.main ]
}

# 4. Configura um Blueprint de Ambiente. Usamos o "DefaultDataLake" como padrão.
# Um blueprint é um template para criar ambientes (ex: S3, Redshift, Athena).
data "aws_datazone_environment_blueprint" "managed" {
  # Transforma a lista de strings em um mapa para o for_each
  for_each = toset(var.enabled_blueprint_names)

  domain_id = aws_datazone_domain.main.id # Assumindo que o domínio já foi criado
  name      = each.key                  # Usa o nome do blueprint (ex: "DefaultDataLake")
  managed   = true                      # Importante para blueprints padrão

  depends_on = [ aws_datazone_domain.main ]
}

resource "aws_datazone_environment_blueprint_configuration" "main" {
  for_each = data.aws_datazone_environment_blueprint.managed

  domain_id                = aws_datazone_domain.main.id
  environment_blueprint_id = each.value.id # Pega o ID do blueprint encontrado
  enabled_regions          = var.enabled_regions
  provisioning_role_arn    = var.provisioning_role_arn

  depends_on = [ aws_datazone_domain.main ]
}

# 5. Cria um Glossário de Negócios dentro do projeto.
resource "aws_datazone_glossary" "main" {
  domain_identifier         = aws_datazone_domain.main.id
  owning_project_identifier = aws_datazone_project.main.id
  name                      = var.glossary_name
  status                    = "ENABLED"

  depends_on = [ aws_datazone_domain.main, aws_datazone_project.main ]
}

# 6. (Opcional) Adiciona um termo ao glossário.
resource "aws_datazone_glossary_term" "example_term" {
  # Apenas cria se um nome de termo for fornecido.
  count = var.glossary_initial_term_name != "" ? 1 : 0

  domain_identifier   = aws_datazone_domain.main.id
  glossary_identifier = aws_datazone_glossary.main.id
  name                = var.glossary_initial_term_name
  status              = "ENABLED"

  depends_on = [ aws_datazone_domain.main, aws_datazone_glossary.main ]
}


#---------------------------------------------------------------------------------
# 📌 ATENÇÃO SOBRE O CÓDIGO A SEGUIR (DataZone Assets via Lambda Custom Resource)
#
# Atualmente (ago/2025), o Amazon DataZone ainda não oferece suporte nativo
# para criação de "Assets" através do CloudFormation nem do Terraform Provider.
# 
# Isso significa que não existe hoje um recurso oficial como 
# `aws_datazone_asset` ou `awscc_datazone_asset` que permita
# gerenciar Assets de forma declarativa (como fazemos com Domain, Project, 
# Glossary, Blueprints, etc.).
#
# Para contornar essa limitação, este módulo cria uma AWS Lambda que implementa
# um "Custom Resource" do CloudFormation. Essa Lambda chama diretamente a API
# do DataZone (`create_asset`) para provisionar os Assets declarados no Terraform.
#
# Por que essa abordagem?
# - Mantém a criação de Assets dentro do fluxo IaC (Terraform), sem precisar
#   rodar scripts externos manualmente.
# - Encapsula a lógica de criação em um único ponto (a Lambda), facilitando
#   manutenção e evolução.
# - Garante consistência entre o que está definido em Terraform e o que é
#   efetivamente criado no DataZone.
#
# O que pode mudar no futuro?
# - Assim que a AWS liberar suporte oficial a Assets no CloudFormation/Terraform,
#   este módulo poderá ser substituído por um simples `resource "aws_datazone_asset"`.
# - Para facilitar essa transição, a interface (variáveis de entrada) já segue o
#   padrão esperado de um recurso nativo: lista de objetos `assets` com
#   `name`, `type` e `description`.
# - Com isso, a troca será transparente para os módulos consumidores, bastando
#   remover a Lambda e mapear para o recurso nativo.
#
# Em resumo:
# - HOJE: Lambda Custom Resource (única forma possível).
# - FUTURO: Recurso nativo Terraform/CloudFormation assim que a AWS expor.
#---------------------------------------------------------------------------------------

# Cria a Lambda que vai orquestrar os Assets
resource "aws_iam_role" "assets_lambda_role" {
  name               = "${var.name_prefix}-assets-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = { Service = "lambda.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

# Anexa a AWSLambdaBasicExecutionRole
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.assets_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

  depends_on = [ aws_iam_role.assets_lambda_role ]
}
# Anexa a AWSLambdaVPCAccessExecutionRole
resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role       = aws_iam_role.assets_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"

  depends_on = [ aws_iam_role.assets_lambda_role ]
}

# Anexa o AmazonDataZoneFullAccess
resource "aws_iam_role_policy_attachment" "datazone_full_access" {
  role       = aws_iam_role.assets_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDataZoneFullAccess"

  depends_on = [ aws_iam_role.assets_lambda_role ]
}

# Cria lambda assets
resource "aws_lambda_function" "assets" {
  # checkov:skip=CKV_AWS_272: The Costume not will use because change all structure the pipeline. Not applicable. 
  # checkov:skip=CKV_AWS_116: The lambda will not working with sqs dlq service. It's separated.
  # checkov:skip=CKV_AWS_50: The module its ready to work with X-RAY but it's not necessary be obligatory.
  # checkov:skip=CKV_AWS_115: The module its ready to work reserved concurrent executions but default value is unlimited and each lambda have your definition.
  function_name = "${var.name_prefix}-datazone-assets"
  role          = aws_iam_role.assets_lambda_role.arn
  runtime       = "python3.11"
  handler       = "index.handler"
  timeout       = 300

  filename         = "${path.module}/templates/assets/index.zip"
  source_code_hash = filebase64sha256("${path.module}/templates/assets/index.zip")

  dynamic "vpc_config" {
    for_each = var.enable_vpc ? [1] : []
    content {
      subnet_ids         = var.subnet_ids
      security_group_ids = var.security_group_ids
    }
  }

  dynamic "dead_letter_config" {
    for_each = var.dlq_target_arn != "" && var.dlq_target_arn != null ? [1] : []
    content {
      target_arn = var.dlq_target_arn
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic_execution,
    aws_iam_role_policy_attachment.datazone_full_access,
    aws_datazone_domain.main
  ]
}

# Cria lambda association
resource "aws_lambda_function" "association" {
  # checkov:skip=CKV_AWS_272: The Costume not will use because change all structure the pipeline. Not applicable. 
  # checkov:skip=CKV_AWS_116: The lambda will not working with sqs dlq service. It's separated.
  # checkov:skip=CKV_AWS_50: The module its ready to work with X-RAY but it's not necessary be obligatory.
  # checkov:skip=CKV_AWS_115: The module its ready to work reserved concurrent executions but default value is unlimited and each lambda have your definition.
  function_name = "${var.name_prefix}-datazone-association"
  role          = aws_iam_role.assets_lambda_role.arn
  runtime       = "python3.11"
  handler       = "index.handler"
  timeout       = 300

  filename         = "${path.module}/templates/association/index.zip"
  source_code_hash = filebase64sha256("${path.module}/templates/association/index.zip")

  dynamic "vpc_config" {
    for_each = var.enable_vpc ? [1] : []
    content {
      subnet_ids         = var.subnet_ids
      security_group_ids = var.security_group_ids
    }
  }

  dynamic "dead_letter_config" {
    for_each = var.dlq_target_arn != "" && var.dlq_target_arn != null ? [1] : []
    content {
      target_arn = var.dlq_target_arn
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic_execution,
    aws_iam_role_policy_attachment.datazone_full_access,
    aws_datazone_domain.main
  ]
}

resource "aws_lambda_invocation" "assets" {
  function_name = aws_lambda_function.assets.function_name
  input = jsonencode({
    RequestType = "Create"
    ResourceProperties = {
      DomainId = aws_datazone_domain.main.id
      ProjectId = aws_datazone_project.main.id
      Assets = var.assets
    }
  })

  depends_on = [ 
    aws_lambda_function.association,
    aws_datazone_domain.main,
    aws_datazone_project.main
  ]
}

resource "aws_lambda_invocation" "associate_accounts" {
  function_name = aws_lambda_function.association.function_name
  input = jsonencode({
    RequestType = "Create"
    ResourceProperties = {
      DomainId    = aws_datazone_domain.main.id
      ProjectId   = aws_datazone_project.main.id
      Accounts    = var.account_associations
    }
  })

  depends_on = [ 
    aws_lambda_function.association,
    aws_datazone_domain.main,
    aws_datazone_project.main
  ]
}