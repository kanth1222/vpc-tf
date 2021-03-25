variable "aws_region" {
  type = string
}

variable "additional_tags" {
  type    = map(string)
  default = {}
}

variable "availability_zones" {
  type    = list(string)
  default = ["use2-az1", "use2-az2"]
}

variable "account_id" {
  type = string
}

variable "account_name" {
  type = string
}

variable "allowed_prefixes" {
  type = list(string)
}

variable "association_id" {
  default = "51469228-5ead-45f8-a473-a045e21f5faa"
}

variable "dxg_name" {
  type = string
}

variable "each_vpc" {
  type = map(
    object({
      cidr_block             = string
      region                 = string
      transit_gateway_routes = list(string)
    })
  )
}

variable "environment_tag" {
  type = string
}

variable "git_repo_url" {
  type    = string
  default = "I should fill this out so I do not embarrass my self."
}

variable "owner_account_id" {
  type    = string
  default = "155510101027"
}

variable "ptfe_token" {
  type = string
}

variable "ptfe_workspace_url" {
  type    = string
  default = "I should fill this out so I do not embarrass my self."
}

variable "region_abbreviation" {
  type = string
}

variable "role_arn" {
  type = string
}
