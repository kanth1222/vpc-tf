resource "aws_cloudwatch_log_group" "vpc_flow_log" {
  count = length(var.each_vpc) > 0 ? 1 : 0 # if each_vpc has 1 or more elements in this region, create the this thing.

  name = "${var.environment_tag}-${var.region_abbreviation}_vpc_flow_log"

  retention_in_days = 14

  tags = merge(
    {
      deployed_by        = "terraform"
      environment        = var.environment_tag
      ptfe_workspace_url = var.ptfe_workspace_url
      git_repo_url       = var.git_repo_url
    },
  )

  depends_on = [aws_vpc.main]
}

resource "aws_flow_log" "main" {
  for_each        = var.each_vpc
  iam_role_arn    = aws_iam_role.vpc_flow_log.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_log[0].arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main[each.key].id
}

