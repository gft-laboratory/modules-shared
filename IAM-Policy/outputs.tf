output "iam_policy_arn" {
  description = "ARN da policy IAM criada (se aplicável)"
  value       = length(aws_iam_policy.iam_policy) > 0 ? aws_iam_policy.iam_policy[0].arn : null
}

output "iam_policy_name" {
  description = "Nome da policy IAM criada (se aplicável)"
  value       = length(aws_iam_policy.iam_policy) > 0 ? aws_iam_policy.iam_policy[0].name : null
}

output "custom_policy_attached" {
  description = "Indica se a policy customizada foi anexada a uma role"
  value       = length(aws_iam_role_policy_attachment.custom_policy_attach) > 0
}

output "managed_policies_attached" {
  description = "Lista das managed policies anexadas à role"
  value       = keys(aws_iam_role_policy_attachment.managed)
}
