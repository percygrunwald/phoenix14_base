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

data "aws_ami" "centos7" {
  owners      = ["679593333241"]
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_instance" "app" {
  count                       = "${var.count}"
  ami                         = "${data.aws_ami.centos7.id}"
  instance_type               = "${var.instance_size}"
  subnet_id                   = "${element(data.terraform_remote_state.vpc.public_subnets, count.index)}"
  vpc_security_group_ids      = ["${data.terraform_remote_state.sg.app_security_group_id}"]
  key_name                    = "${var.aws_keypair}"
  associate_public_ip_address = "${var.assign_public_ip}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = "${var.disk_size_gb}"
    delete_on_termination = true
  }

  tags = {
    Name        = "${var.app_name_hyphen}-${var.env}-app"
    Org         = "${var.org}"
    Environment = "${var.env}"
    Application = "${var.app_name_underscore}"
    Owner       = "${var.owner}"
  }
}
