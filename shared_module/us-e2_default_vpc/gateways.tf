resource "aws_internet_gateway" "main" {
  for_each = var.each_vpc

  vpc_id = aws_vpc.main[each.key].id

  tags = merge(
    {
      Name               = "${aws_vpc.main[each.key].tags.Name}_igw"
      deployed_by        = "terraform"
      environment        = var.environment_tag
      ptfe_workspace_url = var.ptfe_workspace_url
      git_repo_url       = var.git_repo_url
    },
    var.additional_tags
  )
}

resource "aws_eip" "nat_gateway" {
  for_each         = local.each_public_subnet
  vpc              = true
  public_ipv4_pool = "amazon"

  tags = merge(
    {
      Name               = "${aws_subnet.main[each.key].tags.Name}_nat-eipalloc"
      deployed_by        = "terraform"
      environment        = var.environment_tag
      ptfe_workspace_url = var.ptfe_workspace_url
      git_repo_url       = var.git_repo_url
    },
    var.additional_tags
  )
}

resource "aws_nat_gateway" "main" {
  for_each      = local.each_public_subnet
  allocation_id = aws_eip.nat_gateway[each.key].id
  subnet_id     = aws_subnet.main[each.key].id

  tags = merge(
    {
      Name               = "${aws_subnet.main[each.key].tags.Name}_nat"
      deployed_by        = "terraform"
      environment        = var.environment_tag
      ptfe_workspace_url = var.ptfe_workspace_url
      git_repo_url       = var.git_repo_url
    },
    var.additional_tags
  )
}
