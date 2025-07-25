##################################
# Get ID of created Security Group
##################################
locals {
  create = var.create 
  this_sg_id = var.create_sg ? concat(aws_security_group.custom_sg.*.id, [""])[0] : var.security_group_id
}

resource "aws_security_group" "custom_sg" {
# checkov:skip=CKV_AWS_23: The description is created like variable to attach in each rule.
# checkov:skip=CKV2_AWS_5: The security group is defined to be attached in other modules like Lambda, EC2, DMS etc.

  count = local.create && var.create_sg ? 1 : 0

  name   = var.name
  vpc_id = var.vpc_id
  tags   = var.tags
}

resource "aws_security_group_rule" "ingress_rules" {
  count = local.create ? length(var.ingress_rules) : 0

  security_group_id = local.this_sg_id
  type              = "ingress"

  cidr_blocks      = var.ingress_cidr_blocks
  ipv6_cidr_blocks = var.ingress_ipv6_cidr_blocks
  prefix_list_ids  = var.ingress_prefix_list_ids
  description      = var.rules[var.ingress_rules[count.index]][3]

  from_port = var.rules[var.ingress_rules[count.index]][0]
  to_port   = var.rules[var.ingress_rules[count.index]][1]
  protocol  = var.rules[var.ingress_rules[count.index]][2]
}


##########################
# Ingress - Maps of rules
##########################
# Security group rules with "source_security_group_id", but without "cidr_blocks" and "self"
resource "aws_security_group_rule" "ingress_with_source_security_group_id" {
  count = local.create ? length(var.ingress_with_source_security_group_id) : 0

  security_group_id = local.this_sg_id
  type              = "ingress"

  source_security_group_id = var.ingress_with_source_security_group_id[count.index]["source_security_group_id"]
  prefix_list_ids          = var.ingress_prefix_list_ids
  description = lookup(
    var.ingress_with_source_security_group_id[count.index],
    "description",
    "Ingress Rule",
  )

  from_port = lookup(
    var.ingress_with_source_security_group_id[count.index],
    "from_port",
    var.rules[lookup(
      var.ingress_with_source_security_group_id[count.index],
      "rule",
      "_",
    )][0],
  )
  to_port = lookup(
    var.ingress_with_source_security_group_id[count.index],
    "to_port",
    var.rules[lookup(
      var.ingress_with_source_security_group_id[count.index],
      "rule",
      "_",
    )][1],
  )
  protocol = lookup(
    var.ingress_with_source_security_group_id[count.index],
    "protocol",
    var.rules[lookup(
      var.ingress_with_source_security_group_id[count.index],
      "rule",
      "_",
    )][2],
  )
}

# Security group rules with "cidr_blocks", but without "ipv6_cidr_blocks", "source_security_group_id" and "self"
resource "aws_security_group_rule" "ingress_with_cidr_blocks" {
  count = local.create ? length(var.ingress_with_cidr_blocks) : 0

  security_group_id = local.this_sg_id
  type              = "ingress"

  cidr_blocks = compact(split(
    ",",
    lookup(
      var.ingress_with_cidr_blocks[count.index],
      "cidr_blocks",
      join(",", var.ingress_cidr_blocks),
    ),
  ))
  prefix_list_ids = var.ingress_prefix_list_ids
  description = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "description",
    "Ingress Rule",
  )

  from_port = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "from_port",
    var.rules[lookup(var.ingress_with_cidr_blocks[count.index], "rule", "_")][0],
  )
  to_port = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "to_port",
    var.rules[lookup(var.ingress_with_cidr_blocks[count.index], "rule", "_")][1],
  )
  protocol = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "protocol",
    var.rules[lookup(var.ingress_with_cidr_blocks[count.index], "rule", "_")][2],
  )
}

# Security group rules with "ipv6_cidr_blocks", but without "cidr_blocks", "source_security_group_id" and "self"
resource "aws_security_group_rule" "ingress_with_ipv6_cidr_blocks" {
  count = local.create ? length(var.ingress_with_ipv6_cidr_blocks) : 0

  security_group_id = local.this_sg_id
  type              = "ingress"

  ipv6_cidr_blocks = compact(split(
    ",",
    lookup(
      var.ingress_with_ipv6_cidr_blocks[count.index],
      "ipv6_cidr_blocks",
      join(",", var.ingress_ipv6_cidr_blocks),
    ),
  ))
  prefix_list_ids = var.ingress_prefix_list_ids
  description = lookup(
    var.ingress_with_ipv6_cidr_blocks[count.index],
    "description",
    "Ingress Rule",
  )

  from_port = lookup(
    var.ingress_with_ipv6_cidr_blocks[count.index],
    "from_port",
    var.rules[lookup(var.ingress_with_ipv6_cidr_blocks[count.index], "rule", "_")][0],
  )
  to_port = lookup(
    var.ingress_with_ipv6_cidr_blocks[count.index],
    "to_port",
    var.rules[lookup(var.ingress_with_ipv6_cidr_blocks[count.index], "rule", "_")][1],
  )
  protocol = lookup(
    var.ingress_with_ipv6_cidr_blocks[count.index],
    "protocol",
    var.rules[lookup(var.ingress_with_ipv6_cidr_blocks[count.index], "rule", "_")][2],
  )
}

# Security group rules with "self", but without "cidr_blocks" and "source_security_group_id"
resource "aws_security_group_rule" "ingress_with_self" {
  count = local.create ? length(var.ingress_with_self) : 0

  security_group_id = local.this_sg_id
  type              = "ingress"

  self            = lookup(var.ingress_with_self[count.index], "self", true)
  prefix_list_ids = var.ingress_prefix_list_ids
  description = lookup(
    var.ingress_with_self[count.index],
    "description",
    "Ingress Rule",
  )

  from_port = lookup(
    var.ingress_with_self[count.index],
    "from_port",
    var.rules[lookup(var.ingress_with_self[count.index], "rule", "_")][0],
  )
  to_port = lookup(
    var.ingress_with_self[count.index],
    "to_port",
    var.rules[lookup(var.ingress_with_self[count.index], "rule", "_")][1],
  )
  protocol = lookup(
    var.ingress_with_self[count.index],
    "protocol",
    var.rules[lookup(var.ingress_with_self[count.index], "rule", "_")][2],
  )
}

# Security group rules with "prefix_list_ids", but without "cidr_blocks", "self" or "source_security_group_id"
resource "aws_security_group_rule" "ingress_with_prefix_list_ids" {
  count = var.create ? length(var.ingress_with_prefix_list_ids) : 0

  security_group_id = local.this_sg_id
  type              = "ingress"

  prefix_list_ids = var.ingress_prefix_list_ids
  description = lookup(
    var.ingress_with_prefix_list_ids[count.index],
    "description",
    "Ingress Rule",
  )

  from_port = lookup(
    var.ingress_with_prefix_list_ids[count.index],
    "from_port",
    var.rules[lookup(var.ingress_with_prefix_list_ids[count.index], "rule", "_")][0],
  )
  to_port = lookup(
    var.ingress_with_prefix_list_ids[count.index],
    "to_port",
    var.rules[lookup(var.ingress_with_prefix_list_ids[count.index], "rule", "_")][1],
  )
  protocol = lookup(
    var.ingress_with_prefix_list_ids[count.index],
    "protocol",
    var.rules[lookup(var.ingress_with_prefix_list_ids[count.index], "rule", "_")][2],
  )
}

#################
# End of ingress
#################

##################################
# Egress - List of rules (simple)
##################################
# Security group rules with "cidr_blocks" and it uses list of rules names
resource "aws_security_group_rule" "egress_rules" {
  count = local.create ? length(var.egress_rules) : 0

  security_group_id = local.this_sg_id
  type              = "egress"

  cidr_blocks      = var.egress_cidr_blocks
  ipv6_cidr_blocks = var.egress_ipv6_cidr_blocks
  prefix_list_ids  = var.egress_prefix_list_ids
  description      = var.rules[var.egress_rules[count.index]][3]

  from_port = var.rules[var.egress_rules[count.index]][0]
  to_port   = var.rules[var.egress_rules[count.index]][1]
  protocol  = var.rules[var.egress_rules[count.index]][2]
}

#########################
# Egress - Maps of rules
#########################
# Security group rules with "source_security_group_id", but without "cidr_blocks" and "self"
resource "aws_security_group_rule" "egress_with_source_security_group_id" {
  count = local.create ? length(var.egress_with_source_security_group_id) : 0

  security_group_id = local.this_sg_id
  type              = "egress"

  source_security_group_id = var.egress_with_source_security_group_id[count.index]["source_security_group_id"]
  prefix_list_ids          = var.egress_prefix_list_ids
  description = lookup(
    var.egress_with_source_security_group_id[count.index],
    "description",
    "Egress Rule",
  )

  from_port = lookup(
    var.egress_with_source_security_group_id[count.index],
    "from_port",
    var.rules[lookup(
      var.egress_with_source_security_group_id[count.index],
      "rule",
      "_",
    )][0],
  )
  to_port = lookup(
    var.egress_with_source_security_group_id[count.index],
    "to_port",
    var.rules[lookup(
      var.egress_with_source_security_group_id[count.index],
      "rule",
      "_",
    )][1],
  )
  protocol = lookup(
    var.egress_with_source_security_group_id[count.index],
    "protocol",
    var.rules[lookup(
      var.egress_with_source_security_group_id[count.index],
      "rule",
      "_",
    )][2],
  )
}

# Security group rules with "cidr_blocks", but without "ipv6_cidr_blocks", "source_security_group_id" and "self"
resource "aws_security_group_rule" "egress_with_cidr_blocks" {
  count = local.create ? length(var.egress_with_cidr_blocks) : 0

  security_group_id = local.this_sg_id
  type              = "egress"

  cidr_blocks = compact(split(
    ",",
    lookup(
      var.egress_with_cidr_blocks[count.index],
      "cidr_blocks",
      join(",", var.egress_cidr_blocks),
    ),
  ))
  prefix_list_ids = var.egress_prefix_list_ids
  description = lookup(
    var.egress_with_cidr_blocks[count.index],
    "description",
    "Egress Rule",
  )

  from_port = lookup(
    var.egress_with_cidr_blocks[count.index],
    "from_port",
    var.rules[lookup(var.egress_with_cidr_blocks[count.index], "rule", "_")][0],
  )
  to_port = lookup(
    var.egress_with_cidr_blocks[count.index],
    "to_port",
    var.rules[lookup(var.egress_with_cidr_blocks[count.index], "rule", "_")][1],
  )
  protocol = lookup(
    var.egress_with_cidr_blocks[count.index],
    "protocol",
    var.rules[lookup(var.egress_with_cidr_blocks[count.index], "rule", "_")][2],
  )
}

# Security group rules with "ipv6_cidr_blocks", but without "cidr_blocks", "source_security_group_id" and "self"
resource "aws_security_group_rule" "egress_with_ipv6_cidr_blocks" {
  count = local.create ? length(var.egress_with_ipv6_cidr_blocks) : 0

  security_group_id = local.this_sg_id
  type              = "egress"

  ipv6_cidr_blocks = compact(split(
    ",",
    lookup(
      var.egress_with_ipv6_cidr_blocks[count.index],
      "ipv6_cidr_blocks",
      join(",", var.egress_ipv6_cidr_blocks),
    ),
  ))
  prefix_list_ids = var.egress_prefix_list_ids
  description = lookup(
    var.egress_with_ipv6_cidr_blocks[count.index],
    "description",
    "Egress Rule",
  )

  from_port = lookup(
    var.egress_with_ipv6_cidr_blocks[count.index],
    "from_port",
    var.rules[lookup(var.egress_with_ipv6_cidr_blocks[count.index], "rule", "_")][0],
  )
  to_port = lookup(
    var.egress_with_ipv6_cidr_blocks[count.index],
    "to_port",
    var.rules[lookup(var.egress_with_ipv6_cidr_blocks[count.index], "rule", "_")][1],
  )
  protocol = lookup(
    var.egress_with_ipv6_cidr_blocks[count.index],
    "protocol",
    var.rules[lookup(var.egress_with_ipv6_cidr_blocks[count.index], "rule", "_")][2],
  )
}

# Security group rules with "self", but without "cidr_blocks" and "source_security_group_id"
resource "aws_security_group_rule" "egress_with_self" {
  count = local.create ? length(var.egress_with_self) : 0

  security_group_id = local.this_sg_id
  type              = "egress"

  self            = lookup(var.egress_with_self[count.index], "self", true)
  prefix_list_ids = var.egress_prefix_list_ids
  description = lookup(
    var.egress_with_self[count.index],
    "description",
    "Egress Rule",
  )

  from_port = lookup(
    var.egress_with_self[count.index],
    "from_port",
    var.rules[lookup(var.egress_with_self[count.index], "rule", "_")][0],
  )
  to_port = lookup(
    var.egress_with_self[count.index],
    "to_port",
    var.rules[lookup(var.egress_with_self[count.index], "rule", "_")][1],
  )
  protocol = lookup(
    var.egress_with_self[count.index],
    "protocol",
    var.rules[lookup(var.egress_with_self[count.index], "rule", "_")][2],
  )
}

# Security group rules with "egress_prefix_list_ids", but without "cidr_blocks", "self" or "source_security_group_id"
resource "aws_security_group_rule" "egress_with_prefix_list_ids" {
  count = var.create ? length(var.egress_with_prefix_list_ids) : 0

  security_group_id = local.this_sg_id
  type              = "egress"

  prefix_list_ids = var.egress_prefix_list_ids
  description = lookup(
    var.egress_with_prefix_list_ids[count.index],
    "description",
    "Egress Rule",
  )

  from_port = lookup(
    var.egress_with_prefix_list_ids[count.index],
    "from_port",
    var.rules[lookup(
      var.egress_with_prefix_list_ids[count.index],
      "rule",
      "_",
    )][0],
  )
  to_port = lookup(
    var.egress_with_prefix_list_ids[count.index],
    "to_port",
    var.rules[lookup(
      var.egress_with_prefix_list_ids[count.index],
      "rule",
      "_",
    )][1],
  )
  protocol = lookup(
    var.egress_with_prefix_list_ids[count.index],
    "protocol",
    var.rules[lookup(
      var.egress_with_prefix_list_ids[count.index],
      "rule",
      "_",
    )][2],
  )
}

################
# End of egress
################