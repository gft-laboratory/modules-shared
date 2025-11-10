output "vpc_endpoint_ids" {
  description = "IDs dos VPC Endpoints criados"
  value = { for k, ep in aws_vpc_endpoint.this : k => ep.id }
}

output "vpc_endpoint_dns_entries" {
  description = "DNS entries dos endpoints Interface"
  value = {
    for k, ep in aws_vpc_endpoint.this :
    k => ep.dns_entry if ep.vpc_endpoint_type == "Interface"
  }
}

output "vpc_endpoint_network_interface_ids" {
  description = "Network Interface IDs (apenas para Interface Endpoints)"
  value = {
    for k, ep in aws_vpc_endpoint.this :
    k => ep.network_interface_ids if ep.vpc_endpoint_type == "Interface"
  }
}

output "vpc_endpoint_arns" {
  description = "ARNs dos VPC Endpoints"
  value = { for k, ep in aws_vpc_endpoint.this : k => ep.arn }
}
