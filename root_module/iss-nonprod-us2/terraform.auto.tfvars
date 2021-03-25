account_id       = "004665482139"
account_name     = "iss-nonprod"
allowed_prefixes = ["172.25.16.0/20", "172.25.32.0/19", "172.25.64.0/18"]
aws_region       = "us-east-2"
dxg_name         = "iss-nonprod-dxg"
each_vpc = {
  vpc1 = {
    cidr_block = "172.25.16.0/24",
    transit_gateway_routes = [
      "172.16.0.0/12"
    ],
    region = "us-east-2",
  }
}
environment_tag    = "nonprod"
git_repo_url       = "https://gitlab.com/petco/cloud-infrastructure-services/aws_customers_prod/iss-nonprod/-/tree/master/environments/nonprod/us-2"
ptfe_token         = "OFltd7zA4okAIA.atlasv1.8HpMxgq9zpuXh555jzunXtXzxKZxzuKw5wRnh25arOBAezF9lj1VGXdmevFNwElzHPo"
ptfe_workspace_url = "https://terraform.petco.com/app/Infrastructure/workspaces/iss-nonprod-vpc"
role_arn           = "arn:aws:iam::004665482139:role/svc_terraform_apparatus"
