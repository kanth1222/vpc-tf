# US east 2 settings
locals {
  # Settings for each region we're enabling.
  region_settings = {
    us-east-2 = {
      region_abbreviation = "us-e2"
      availability_zones  = ["use2-az1", "use2-az2"]
      cidr_block = {
        for key, value in var.each_vpc :
        key => value
        if value.region == "us-east-2"
      }
    }
  }
}