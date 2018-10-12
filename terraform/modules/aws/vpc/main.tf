terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.app_name_hyphen}-${var.env}"

  cidr             = "${var.cidr}"
  private_subnets  = "${var.private_subnets}"
  public_subnets   = "${var.public_subnets}"
  database_subnets = "${var.database_subnets}"

  azs = "${var.azs}"

  create_database_subnet_group = "${var.create_database_subnet_group}"

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = "${var.enable_nat_gateway}"

  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.name}"
    Org         = "${var.org}"
    Environment = "${var.env}"
    Application = "${var.app_name_underscore}"
    Owner       = "${var.owner}"
  }
}
