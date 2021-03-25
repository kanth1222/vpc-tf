locals {
  # Subnet templates for one private and one public subnet in each AZ.
  # The netnums will keep the private subnets in the first half of the vpc allocation
  # And the public subnets in the latter half.
  subnet_templates = flatten([
    for index, availability_zone in var.availability_zones : [
      {
        name_suffix = "${split("-", availability_zone)[1]}-private-subnet"
        az_id       = availability_zone
        public      = false
        netnum      = 0 + index
        # key_suffix of the public subnet that will hold its nat gateway
        nat_gatway_key_suffix   = "${split("-", availability_zone)[1]}-public-subnet"
        map_public_ip_on_launch = false
      },
      {
        name_suffix             = "${split("-", availability_zone)[1]}-public-subnet"
        az_id                   = availability_zone
        public                  = true
        netnum                  = length(var.availability_zones) + index
        map_public_ip_on_launch = true
      }
    ]
  ])

  # List of each subnet object, by template, for each vpc
  subnets = flatten([
    for key, value in var.each_vpc : [
      for subnet in local.subnet_templates : {
        name                    = "${aws_vpc.main[key].tags.Name}_${subnet.name_suffix}"
        vpc_id                  = aws_vpc.main[key].id
        az_id                   = subnet.az_id
        public                  = subnet.public
        map_public_ip_on_launch = subnet.map_public_ip_on_launch
        vpc_key                 = key
        # If the subnet is private, save the key of the public subnet that will hold its nat gateway.
        # Otherwise set to null, since it will not be used.
        nat_gateway_key = !subnet.public ? "${aws_vpc.main[key].tags.Name}_${subnet.nat_gatway_key_suffix}" : null
        # Calculate subnet cidr_blocks based on vpc allocation and number of subnets.
        # https://www.terraform.io/docs/configuration/functions/cidrsubnet.html
        # Finding the minimum number newbits required to contain a number of equal-sized subnets per vpc.
        # https://www.terraform.io/docs/configuration/functions/log.html#examples
        cidr_block = cidrsubnet(value.cidr_block, ceil(log(length(local.subnet_templates), 2)), subnet.netnum)
      }
    ]
  ])

  # convert list to map for consumption by for_each
  each_subnet = {
    for subnet in local.subnets :
    subnet.name => subnet
  }

  # filter each_subnet by public boolean for use elsewhere
  each_public_subnet = {
    for key, value in local.each_subnet :
    key => value
    if value.public
  }
  each_private_subnet = {
    for key, value in local.each_subnet :
    key => value
    if !value.public
  }
}

resource "aws_subnet" "main" {
  for_each = local.each_subnet

  vpc_id               = each.value.vpc_id
  cidr_block           = each.value.cidr_block
  availability_zone_id = each.value.az_id

  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = merge(
    {
      Name               = each.key
      deployed_by        = "terraform"
      environment        = var.environment_tag
      ptfe_workspace_url = var.ptfe_workspace_url
      git_repo_url       = var.git_repo_url
      public             = each.value.public
    },
    var.additional_tags
  )

}
