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
| [aws_iam_policy.iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attach_policy_in_role"></a> [attach\_policy\_in\_role](#input\_attach\_policy\_in\_role) | Condition to attach or not policy in role, because have some policy that is not necessary a role | `bool` | `true` | no |
| <a name="input_policy_description"></a> [policy\_description](#input\_policy\_description) | Description of the IAM policy | `any` | n/a | yes |
| <a name="input_policy_document"></a> [policy\_document](#input\_policy\_document) | JSON string representing the IAM policy document | `any` | n/a | yes |
| <a name="input_policy_managed_arn"></a> [policy\_managed\_arn](#input\_policy\_managed\_arn) | Name of the IAM policy optional | `any` | n/a | yes |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | Name of the IAM policy | `any` | n/a | yes |
| <a name="input_policy_path"></a> [policy\_path](#input\_policy\_path) | Path for the IAM policy | `any` | n/a | yes |
| <a name="input_role_attach_policy_managed_name"></a> [role\_attach\_policy\_managed\_name](#input\_role\_attach\_policy\_managed\_name) | Name of the IAM role | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_policy_arn"></a> [iam\_policy\_arn](#output\_iam\_policy\_arn) | ARN of the created IAM policy |
