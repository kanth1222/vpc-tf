resource "aws_default_security_group" "main" {
  for_each = var.each_vpc
  vpc_id   = aws_vpc.main[each.key].id
  # No ingress or egress = deny all
  tags = merge(
    {
      Name               = "default"
      deployed_by        = "terraform"
      environment        = var.environment_tag
      ptfe_workspace_url = var.ptfe_workspace_url
      git_repo_url       = var.git_repo_url
    },
  )
}
