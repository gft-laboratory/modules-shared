output "iam_role_name" {
  value = aws_iam_role.role_custom.name
}

output "iam_role_arn" {
  value = aws_iam_role.role_custom.arn
}

output "iam_role_unique_id" {
  value = aws_iam_role.role_custom.unique_id
}