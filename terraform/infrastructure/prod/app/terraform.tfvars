terragrunt = {
  include = {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = ["../vpc", "../sg"]
  }

  terraform {
    source = "${get_env("MODULES_DIR", "..")}//app"
  }
}

instance_size = "t2.micro"
static_ip = true
