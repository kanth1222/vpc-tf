resource "aws_vpc" "main" {
  for_each = var.each_vpc

  cidr_block = each.value.cidr_block

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    {
      Name               = "${var.environment_tag}-${var.region_abbreviation}-${each.key}"
      deployed_by        = "terraform"
      environment        = var.environment_tag
      ptfe_workspace_url = var.ptfe_workspace_url
      git_repo_url       = var.git_repo_url
    },
    var.additional_tags
  )

}
