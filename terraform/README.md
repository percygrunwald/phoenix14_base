# Terraform infrastructure provisioning for Mindoula Server

## Prerequisites

### System requirements

* Terraform 0.9+ `brew install terraform`
* Terragrunt 0.12+ `brew install terragrunt`
* AWS user with permissions, put the access keys in `~/.aws/credentials`:

```text
[profile]
aws_access_key_id = AKIAJEQKABLA7XMKFYZA
aws_secret_access_key = ...
```

### Prepare required files and shell environment

Make sure you have a correct `set_env.sh` before running any commands. **You need to edit `set_env.sh` before running it.**

```bash
cd ./terraform
cp set_env.sh.sample set_env.sh
export ENV=dev
source ./set_env.sh
```

## Launch infrastructure

To launch all the required infrastructure for a given env, run the command below:

```bash
terragrunt apply-all --terragrunt-working-dir "infrastructure/$ENV"
```

This will apply the Terraform configuration for all the directories in the `./infrastructure` directory. The remote state is stored in S3 for the given environment and locked with DynamoDB (managed by terragrunt). If the infrastructure is already in the required state, `apply-all` will do nothing (idempotent).

For specific actions see **General Terraform/terragrunt commands** section.

## General Terraform/terragrunt commands

### Plan all for an environment

```bash
terragrunt plan-all --terragrunt-working-dir "infrastructure/$ENV"
```

### Plan a single infrastructure part

```bash
terragrunt plan --terragrunt-working-dir "./infrastructure/$ENV/app_servers"
```

### Apply all for an environment

```bash
terragrunt apply-all --terragrunt-working-dir "infrastructure/$ENV"
```

### Apply a single infrastructure part

```bash
terragrunt apply --terragrunt-working-dir "./infrastructure/$ENV/app_server"
```

### Destroy all infrastructure

```bash
terragrunt destroy-all --terragrunt-working-dir "infrastructure/$ENV"
```

### Destroy a single infrastructure part

```bash
terragrunt destroy --terragrunt-working-dir "./infrastructure/$ENV/network_security_rules"
```

## Hard reset

To clear the state completely and start again if the Terraform state is too messed up to even do destroy-all:

* Delete the resource group in Azure
* Delete the S3 state bucket and the DynamoDB locking table
* Run `rm -rf ".terragrunt"`
