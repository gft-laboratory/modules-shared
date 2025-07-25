resource "aws_iam_policy" "iam_policy" {
  count       = var.policy_document != null ? 1 : 0

  name        = var.policy_name
  description = var.policy_description
  path        = var.policy_path
  policy      = var.policy_document
}

resource "aws_iam_role_policy_attachment" "custom_policy_attach" {
  count      = var.policy_document != null && var.role_attach_policy_managed_name != null ? 1 : 0
  role       = var.role_attach_policy_managed_name
  policy_arn = aws_iam_policy.iam_policy[0].arn
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)

  role       = var.role_attach_policy_managed_name
  policy_arn = each.value
}
