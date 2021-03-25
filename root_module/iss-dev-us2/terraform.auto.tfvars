account_id       = "223612579215"
account_name     = "iss-dev"
allowed_prefixes = ["172.25.0.0/20"]
aws_region       = "us-east-2"
dxg_name         = "iss-dev-dxg"
each_vpc = {
  vpc1 = {
    cidr_block = "172.25.0.0/24",
    transit_gateway_routes = [
      "172.16.0.0/12"
    ],
    region = "us-east-2",
  }
}
environment_tag     = "dev"
git_repo_url        = "https://gitlab.com/petco/cloud-infrastructure-services/aws_customers_prod/iss-dev/-/tree/master/environments/dev/us-2"
ptfe_token          = "OFltd7zA4okAIA.atlasv1.8HpMxgq9zpuXh555jzunXtXzxKZxzuKw5wRnh25arOBAezF9lj1VGXdmevFNwElzHPo"
ptfe_workspace_url  = "https://terraform.petco.com/app/Infrastructure/workspaces/iss-dev-vpc"
role_arn            = "arn:aws:iam::223612579215:role/svc_terraform_apparatus"
