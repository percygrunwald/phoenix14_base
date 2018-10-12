terragrunt = {
  include = {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = ["../vpc"]
  }

  terraform {
    source = "${get_env("MODULES_DIR", "..")}//sg"
  }
}
