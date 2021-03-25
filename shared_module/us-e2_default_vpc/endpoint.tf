resource "aws_vpc_endpoint" "s3" {
  for_each     = var.each_vpc
  vpc_id       = aws_vpc.main[each.key].id
  service_name = "com.amazonaws.us-east-2.s3"
  tags = merge(
    {
      Name               = "${aws_vpc.main[each.key].tags.Name}_vpce"
      deployed_by        = "terraform"
      environment        = var.environment_tag
      ptfe_workspace_url = var.ptfe_workspace_url
      git_repo_url       = var.git_repo_url
    },
    var.additional_tags
  )
}

# associate route table with VPC endpoint
resource "aws_vpc_endpoint_route_table_association" "route_table_association" {
  for_each        = local.each_private_subnet
  route_table_id  = aws_route_table.private[each.key].id
  vpc_endpoint_id = aws_vpc_endpoint.s3[each.value.vpc_key].id
}
