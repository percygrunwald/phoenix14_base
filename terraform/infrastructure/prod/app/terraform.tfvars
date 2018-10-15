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

count = 2
instance_size = "t2.nano"
