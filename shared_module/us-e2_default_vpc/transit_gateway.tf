// # provider for doing work in the transit gateway account for this region and environment_tag
provider "aws" {
  region = var.aws_region
  alias  = "direct_connect_gateway"
  assume_role {
    role_arn = "arn:aws:iam::155510101027:role/svc_terraform_apparatus"
  }
}

data "aws_caller_identity" "current" {
  provider = aws.direct_connect_gateway
}

data "aws_dx_gateway" "shared" {
  provider = aws.direct_connect_gateway
  name     = "da6-ch3-to-aws"
}

data "aws_ec2_transit_gateway" "main" {}

data "aws_dx_gateway" "main" {
  name = var.dxg_name
}

data "aws_caller_identity" "shared" {}

resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  for_each = var.each_vpc
  subnet_ids = [for subnet_key, subnet in local.each_private_subnet :
    aws_subnet.main[subnet_key].id
  if subnet.vpc_key == each.key]

  transit_gateway_id = data.aws_ec2_transit_gateway.main.id
  vpc_id             = aws_vpc.main[each.key].id
  tags = merge(
    {
      Name               = "${var.account_name}_${aws_vpc.main[each.key].tags.Name}_tgw-attach"
      deployed_by        = "terraform"
      environment        = var.environment_tag
      ptfe_workspace_url = var.ptfe_workspace_url
      git_repo_url       = var.git_repo_url
    },
    var.additional_tags
  )
}

resource "aws_dx_gateway_association_proposal" "main" {
  dx_gateway_id               = data.aws_dx_gateway.shared.id
  dx_gateway_owner_account_id = data.aws_caller_identity.current.account_id
  associated_gateway_id       = data.aws_ec2_transit_gateway.main.id
  allowed_prefixes            = var.allowed_prefixes
}

resource "aws_dx_gateway_association" "main" {
  provider                            = aws.direct_connect_gateway
  proposal_id                         = aws_dx_gateway_association_proposal.main.id
  dx_gateway_id                       = data.aws_dx_gateway.shared.id
  associated_gateway_owner_account_id = data.aws_caller_identity.shared.account_id
}
