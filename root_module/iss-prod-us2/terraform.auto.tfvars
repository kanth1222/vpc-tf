account_id       = "216460352875"
account_name     = "iss-prod"
allowed_prefixes = ["172.25.128.0/17"]
aws_region       = "us-east-2"
dxg_name         = "iss-prod-dxg"
each_vpc = {
  vpc1 = {
    cidr_block = "172.25.128.0/24",
    transit_gateway_routes = [
      "172.16.0.0/12"
    ],
    region = "us-east-2",
  }
}
environment_tag     = "prod"
git_repo_url        = "https://gitlab.com/petco/cloud-infrastructure-services/aws_customers_prod/iss-prod/-/tree/master/environments/prod/us-2"
ptfe_token          = "OFltd7zA4okAIA.atlasv1.8HpMxgq9zpuXh555jzunXtXzxKZxzuKw5wRnh25arOBAezF9lj1VGXdmevFNwElzHPo"
ptfe_workspace_url  = "https://terraform.petco.com/app/Infrastructure/workspaces/iss-prod-vpc"
role_arn            = "arn:aws:iam::216460352875:role/svc_terraform_apparatus"
