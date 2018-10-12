terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_s3_bucket_name}"
    key    = "${var.remote_state_s3_key_prefix}/vpc/terraform.tfstate"
    region = "${var.remote_state_s3_bucket_region}"
  }
}

data "terraform_remote_state" "sg" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_s3_bucket_name}"
    key    = "${var.remote_state_s3_key_prefix}/sg/terraform.tfstate"
    region = "${var.remote_state_s3_bucket_region}"
  }
}

resource "aws_instance" "app" {
  # TODO
}
