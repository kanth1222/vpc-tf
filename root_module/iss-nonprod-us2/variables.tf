variable "account_id" {
  type = string
}

variable "account_name" {
  type = string
}

variable "additional_tags" {
  type    = map(string)
  default = {}
}

variable "allowed_prefixes" {
  type = list(string)
}

variable "aws_region" {
  type = string
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

variable "ptfe_token" {
  type = string
}

variable "ptfe_workspace_url" {
  type    = string
  default = "I should fill this out so I do not embarrass my self."
}

variable "role_arn" {
  type = string
}
