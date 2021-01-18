##################################################################################
# CONFIGURATION - added for Terraform 0.14
##################################################################################

##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  region  = var.region
}



##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {}


##################################################################################
# LOCALS
##################################################################################

locals {
  cidr_block   = var.cidr_block
  subnet_count = var.subnet_count
  common_tags  = {
      name = "Murex VPC"
  }
}

##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~>2.0"

  name = "Murex-Vpc"

  cidr            = local.cidr_block
  azs             = slice(data.aws_availability_zones.available.names, 0, local.subnet_count)
  private_subnets = data.template_file.private_cidrsubnet.*.rendered
  public_subnets  = data.template_file.public_cidrsubnet.*.rendered

  enable_nat_gateway = true

  create_database_subnet_group = true


  tags = local.common_tags
}