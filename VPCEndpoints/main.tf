resource "aws_vpc_endpoint" "this" {
  for_each = var.endpoints

  vpc_id            = var.vpc_id
  service_name      = each.value.service_name
  vpc_endpoint_type = each.value.vpc_endpoint_type
  subnet_ids        = each.value.vpc_endpoint_type == "Interface" ? each.value.subnet_ids : null
  route_table_ids   = each.value.vpc_endpoint_type == "Gateway"   ? each.value.route_table_ids : null
  private_dns_enabled = try(each.value.private_dns_enabled, false)
  security_group_ids  = try(each.value.security_group_ids, null)
  policy              = try(each.value.policy, null)
  tags                = merge(var.default_tags, try(each.value.tags, {}))
}
