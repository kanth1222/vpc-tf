## US east 2
module "us-e2_default_vpc" {
  source = "../../shared_module/us-e2_default_vpc/"

  account_id          = var.account_id
  account_name        = var.account_name
  allowed_prefixes    = var.allowed_prefixes
  availability_zones  = local.region_settings.us-east-2.availability_zones
  aws_region          = var.aws_region
  dxg_name            = var.dxg_name
  each_vpc            = var.each_vpc
  environment_tag     = var.environment_tag
  git_repo_url        = var.git_repo_url
  ptfe_token          = var.ptfe_token
  ptfe_workspace_url  = var.ptfe_workspace_url
  region_abbreviation = local.region_settings.us-east-2.region_abbreviation
  role_arn            = var.role_arn
}
