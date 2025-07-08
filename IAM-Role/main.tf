resource "aws_iam_role" "role_custom" {
  name = "${var.name}-role"

  assume_role_policy = var.assume_role_policy
  permissions_boundary = var.iam_role_permissions_boundary
  
  tags = var.tags_iam_role
}