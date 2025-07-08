resource "aws_iam_policy" "iam_policy" {
  name        = var.policy_name
  description = var.policy_description
  path        = var.policy_path
  policy      = var.policy_document
}

resource "aws_iam_role_policy_attachment" "custom_policy_attach" {
  count      = var.policy_document != null && var.role_attach_policy_managed_name != null ? 1 : 0
  role       = var.role_attach_policy_managed_name
  policy_arn = aws_iam_policy.iam_policy.arn
}

resource "aws_iam_role_policy_attachment" "managed_policy_attach" {
  count      = var.policy_managed_arn != null && var.role_attach_policy_managed_name != null ? 1 : 0
  role       = var.role_attach_policy_managed_name
  policy_arn = var.policy_managed_arn
}