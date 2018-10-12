terragrunt = {
  remote_state {
    backend = "s3"

    config {
      bucket         = "${get_env("ORG", "")}-${get_env("APP_NAME_HYPHEN", "")}-${get_env("ENV", "dev")}-tfstate"
      key            = "${path_relative_to_include()}/terraform.tfstate"
      region         = "${get_env("REMOTE_STATE_S3_BUCKET_REGION", "us-east-1")}"
      encrypt        = true
      dynamodb_table = "${get_env("ORG", "")}-${get_env("APP_NAME_HYPHEN", "")}-tfstate"
    }
  }

  terraform {
    extra_arguments "custom_vars" {
      commands = [
        "apply",
        "plan",
        "import",
        "push",
        "refresh",
        "destroy",
        "force-unlock",
        "apply-all",
        "plan-all",
        "destroy-all",
      ]

      required_var_files = [
        "${get_parent_tfvars_dir()}/terraform.tfvars",
        "${get_parent_tfvars_dir()}/vars/common.tfvars",
        "${get_parent_tfvars_dir()}/vars/env_${get_env("ENV", "dev")}.tfvars",
      ]

      optional_var_files = [
        "${get_parent_tfvars_dir()}/vars/${path_relative_to_include()}/terraform.tfvars",
        "${get_parent_tfvars_dir()}/secrets/common.tfvars",
        "${get_parent_tfvars_dir()}/vars/env_${get_env("ENV", "dev")}.tfvars",
        "${get_parent_tfvars_dir()}/secrets/${path_relative_to_include()}/terraform.tfvars",
      ]

      arguments = []
    }
  }
}
