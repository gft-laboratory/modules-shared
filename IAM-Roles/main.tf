resource "aws_iam_role" "role_custom" {
  name = "${var.name}-role"

  assume_role_policy   = var.assume_role_policy
  permissions_boundary = var.iam_role_permissions_boundary
  
  tags = var.tags_iam_role
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = var.managed_policy_arns != null ? {
    for idx, policy_arn in var.managed_policy_arns : idx => policy_arn
  } : {}

  role       = aws_iam_role.role_custom.name
  policy_arn = each.value
}