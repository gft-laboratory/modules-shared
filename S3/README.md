## S3 Module

This README provides an explanation of each resource used in the Terraform configuration, along with their descriptions, default values, and types.

## How to Use

### Pre-requisites

- [Terraform](https://www.terraform.io/downloads.html) installed.
- AWS credentials configured.

### Example Usage

```hcl
module "s3" {
  source = "./S3"

  bucket_name          = var.bucket_name
  create_bucket_policy = false

  tags_bucket = { 
    Environment = var.environment
    Name        = var.bucket_name
    Module      = "module-application-validation"
  }
}
```

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
| [aws_s3_bucket.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.s3_bucket_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.logging_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_policy.s3_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | n/a | `string` | `""` | no |
| <a name="input_create_bucket_policy"></a> [create\_bucket\_policy](#input\_create\_bucket\_policy) | n/a | `bool` | `false` | no |
| <a name="input_create_lifecycle"></a> [create\_lifecycle](#input\_create\_lifecycle) | n/a | `string` | `"false"` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | n/a | <pre>list(object({<br>    id         = string<br>    expiration = number<br>    prefix     = string<br>  }))</pre> | `[]` | no |
| <a name="input_tags_bucket"></a> [tags\_bucket](#input\_tags\_bucket) | n/a | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | n/a |
