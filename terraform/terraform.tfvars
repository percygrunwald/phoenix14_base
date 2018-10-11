terragrunt {
  remote_state {
    backend = "s3"

    config {
      bucket         = "${get_env("APP_NAME_HYPHEN", "")}-${get_env("ENV", "")}-tfstate"
      key            = "${path_relative_to_include()}/terraform.tfstate"
      region         = "${get_env("REMOTE_STATE_S3_BUCKET_REGION", "us-east-1")}"
      encrypt        = true
      dynamodb_table = "${get_env("APP_NAME_HYPHEN", "")}-${get_env("ENV", "")}-tfstate"
    }
  }

  terraform {
    extra_arguments "custom_vars" {
      commands = [
        "apply",
        "apply-all",
        "plan",
        "plan-all",
        "import",
        "push",
        "refresh",
        "destroy",
        "destroy-all",
      ]

      arguments = [
        "--var-file",
        "${get_env("VARS_DIR", "/path/to/vars")}/common.tfvars",
        "--var-file",
        "${get_env("VARS_DIR", "/path/to/vars")}/env_${get_env("ENV", "dev")}.tfvars",
        "--var-file",
        "${get_env("VARS_DIR", "/path/to/vars")}/secrets/env_${get_env("ENV", "dev")}_secrets.tfvars",
        "-var",
        "env=${get_env("ENV", "")}",
        "-var",
        "app_name_hyphen=${get_env("APP_NAME_HYPHEN", "")}",
        "-var",
        "app_name_underscore=${get_env("APP_NAME_UNDERSCORE", "")}",
        "-var",
        "app_name_alpha=${get_env("APP_NAME_ALPHA", "")}",
        "-var",
        "remote_state_s3_bucket_region=${get_env("REMOTE_STATE_S3_BUCKET_REGION", "us-east-1")}",
        "-var",
        "remote_state_s3_bucket_name=${get_env("APP_NAME_HYPHEN", "")}-${get_env("ENV", "")}-tfstate",
        "-var",
        "remote_state_s3_key_prefix=infrastructure/${get_env("ENV", "")}",
        "-var",
        "lambda_functions_dir=${get_env("VARS_DIR", "/path/to/vars")}/../lambda_functions",
      ]
    }
  }
}
