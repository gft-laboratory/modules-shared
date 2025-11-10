resource "aws_lambda_function" "this" {
  # checkov:skip=CKV_AWS_116: The lambda will not working with sqs dlq service. It's separated.
  # checkov:skip=CKV_AWS_50: The module its ready to work with X-RAY but it's not necessary be obligatory.
  # checkov:skip=CKV_AWS_115: The module its ready to work reserved concurrent executions but default value is unlimited and each lambda have your definition.
  
  function_name = var.function_name
  role          = var.role_arn
  handler       = var.handler
  runtime       = var.runtime
  memory_size   = var.memory_size
  timeout       = var.timeout

  filename         = var.filename
  source_code_hash = filebase64sha256(var.filename)

  reserved_concurrent_executions = var.reserved_concurrent_executions
  code_signing_config_arn        = aws_lambda_code_signing_config.assets.arn
  kms_key_arn                    = var.environment_kms_key_arn

  environment {
    variables = var.environment_variables
  }

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

  tracing_config {
    mode = var.tracing_mode
  }

  tags = var.tags

  depends_on = [ aws_lambda_code_signing_config.assets ]
}

resource "aws_signer_signing_profile" "lambda_signing_profile" {
  platform_id = "AWSLambda-SHA384-ECDSA"
  tags = var.tags
}

resource "aws_lambda_code_signing_config" "assets" {
  description = "Configuração de assinatura para a função Lambda de ativos do DataZone"

  allowed_publishers {
    signing_profile_version_arns = [
      aws_signer_signing_profile.lambda_signing_profile.version_arn
    ]
  }

  policies {
    untrusted_artifact_on_deployment = "Enforce"
  }
}