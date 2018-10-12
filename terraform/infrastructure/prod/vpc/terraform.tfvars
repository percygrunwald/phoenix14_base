terragrunt = {
  include = {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = []
  }

  terraform {
    source = "${get_env("MODULES_DIR", "..")}//vpc"
  }
}

cidr = "10.1.0.0/16"

private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]

public_subnets = ["10.1.11.0/24", "10.1.12.0/24"]

database_subnets = ["10.1.21.0/24", "10.1.22.0/24"]
