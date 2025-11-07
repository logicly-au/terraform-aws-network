data "aws_availability_zones" "available" {}

data "aws_availability_zone" "az" {
  count = length(data.aws_availability_zones.available.names)
  name  = data.aws_availability_zones.available.names[count.index]
}

data "aws_region" "current" {}

data "aws_ec2_managed_prefix_list" "s3" {
  name = "com.amazonaws.${data.aws_region.current.name}.s3"
}

data "aws_ec2_managed_prefix_list" "dynamodb" {
  name = "com.amazonaws.${data.aws_region.current.name}.dynamodb"
}

# Compute effective newbits per tier (tier-specific overrides global)
locals {
  public_newbits_effective   = coalesce(var.public_newbits, var.newbits)
  private_newbits_effective  = coalesce(var.private_newbits, var.newbits)
  secure_newbits_effective   = coalesce(var.secure_newbits, var.newbits)
  transit_newbits_effective  = coalesce(var.transit_newbits, var.newbits)
  firewall_newbits_effective = coalesce(var.firewall_newbits, var.newbits)
}
