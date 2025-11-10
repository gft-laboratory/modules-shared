## 🧬 Lambda Module

Este README documenta os recursos usados para criar uma função AWS Lambda usando Terraform, incluindo parâmetros configuráveis e exemplos de uso.

---

## ⚙️ Como Usar

### ✅ Pré-requisitos

- [Terraform](https://www.terraform.io/downloads.html) instalado.
- AWS credentials configuradas.

### 🚀 Exemplo de Uso

```hcl
module "lambda" {
  source = "./lambda"

  function_name         = "processador-eventos"
  role_arn              = aws_iam_role.lambda_exec.arn
  handler               = "index.handler"
  runtime               = "nodejs18.x"
  memory_size           = 256
  timeout               = 10
  filename              = "./lambda.zip"

  environment_variables = {
    STAGE = "dev"
  }

  tags = {
    Environment = "dev"
    Module      = "lambda"
  }
}
```

---

## 📦 Requirements

Nenhum.

---

## 📡 Providers

| Name | Version |
|------|---------|
| [aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) | n/a |

---

## 🧩 Inputs

| Name                   | Description                                      | Type         | Default | Required |
|------------------------|--------------------------------------------------|--------------|---------|:--------:|
| `function_name`        | Nome da função Lambda                           | `string`     | n/a     | ✅       |
| `role_arn`             | ARN da role IAM associada                       | `string`     | n/a     | ✅       |
| `handler`              | Nome do handler (ex: `index.handler`)           | `string`     | n/a     | ✅       |
| `runtime`              | Runtime da Lambda (ex: `nodejs18.x`)            | `string`     | n/a     | ✅       |
| `memory_size`          | Memória alocada (MB)                            | `number`     | `128`   | ❌       |
| `timeout`              | Timeout da função em segundos                   | `number`     | `3`     | ❌       |
| `filename`             | Caminho para o ZIP do código                    | `string`     | n/a     | ✅       |
| `environment_variables`| Variáveis de ambiente                           | `map(string)`| `{}`    | ❌       |
| `tags`                 | Tags para a função Lambda                       | `map(string)`| `{}`    | ❌       |

---

## 📤 Outputs

| Name                  | Description                  |
|-----------------------|------------------------------|
| `lambda_function_name`| Nome da função Lambda        |
| `lambda_function_arn` | ARN da função Lambda         |
| `lambda_invoke_arn`   | Invoke ARN da função Lambda  |