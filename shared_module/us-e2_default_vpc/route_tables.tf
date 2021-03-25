##########################################################################
# Public Routes
#####################################
resource "aws_route_table" "public" {
  for_each = local.each_public_subnet

  vpc_id = aws_vpc.main[each.value.vpc_key].id

  tags = merge(
    {
      Name               = "${aws_subnet.main[each.key].tags.Name}_rtb"
      deployed_by        = "terraform"
      environment        = var.environment_tag
      ptfe_workspace_url = var.ptfe_workspace_url
      git_repo_url       = var.git_repo_url
    },
    var.additional_tags
  )
}

resource "aws_route" "public_default" {
  for_each = local.each_public_subnet

  route_table_id         = aws_route_table.public[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main[each.value.vpc_key].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public" {
  for_each = local.each_public_subnet

  subnet_id      = aws_subnet.main[each.key].id
  route_table_id = aws_route_table.public[each.key].id
}

##########################################################################
# Private Routes
#####################################
resource "aws_route_table" "private" {
  for_each = local.each_private_subnet

  vpc_id = aws_vpc.main[each.value.vpc_key].id

  tags = merge(
    {
      Name               = "${aws_subnet.main[each.key].tags.Name}_rtb"
      deployed_by        = "terraform"
      environment        = var.environment_tag
      ptfe_workspace_url = var.ptfe_workspace_url
      git_repo_url       = var.git_repo_url
    },
    var.additional_tags
  )
}

resource "aws_route" "private_default" {
  for_each = local.each_private_subnet

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[each.value.nat_gateway_key].id

  timeouts {
    create = "5m"
  }
}

locals {
  # A list of each transit gateway route that we need to make per private route table.
  transit_gateway_routes = flatten([
    for key, value in local.each_private_subnet : [
      for route in var.each_vpc[value.vpc_key].transit_gateway_routes : {
        name                   = "${key}-${route}"
        route_table_key        = key
        destination_cidr_block = route
      }
    ]
  ])
  # Covert list to map for consumption by for_each
  each_transit_gateway_route = {
    for route in local.transit_gateway_routes :
    route.name => route
  }
}

resource "aws_route" "private_transit_gateway" {
  for_each = local.each_transit_gateway_route

  route_table_id         = aws_route_table.private[each.value.route_table_key].id
  destination_cidr_block = each.value.destination_cidr_block
  transit_gateway_id     = data.aws_ec2_transit_gateway.main.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "private" {
  for_each = local.each_private_subnet

  subnet_id      = aws_subnet.main[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}
