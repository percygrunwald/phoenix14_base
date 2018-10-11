# Ansible configuration and deployment for Phoenix14Base Server

## Prerequisites

### System requirements

* Python `asdf install`
* Python pip requirements `pip install -r requirements.txt && asdf reshim python`
* AWS user with permissions, put the access keys in `~/.aws/credentials`:

```text
[profile]
aws_access_key_id = AKIAJEQKABLA7XMKFYZA
aws_secret_access_key = ...
```

### Prepare required files and shell environment

Make sure you have a correct `set_env.sh` before running any commands. **You need to edit `set_env.sh` before running it.**

```bash
cp set_env.sh.sample set_env.sh
export ENV=dev
source ./set_env.sh
```

The `vault.key` must also be installed with the vault key as the contents. Please contact the technical lead for the vault key.

## Configure infrastructure

For all commands, please set `$ANSIBLE_USER` env variable to the correct values depending on whether the `users` role has been run against the instance. If the users role has been run against a particular host, the `$ANSIBLE_USER` env variable should be your username, if not, `centos`.

### Configure app instances

Make sure to update `$BASTION_USER` and `$ANSIBLE_USER` as appropriate.

```bash
ansible-playbook app-configure.yml -D --extra-vars "env=$ENV ansible_user=$ANSIBLE_USER"
```

## Bootstrap database

This assumes that you have completed all the required steps for infrastructure provisioning outlined in `../README.md` and `../terraform/README.md`.

You can connect to the database with any compatible PostgreSQL client. The username and password can be found in the `vars/{{ env }}.vault.yml` file for the current `env` and can be viewed with `ansible-vault`.

After connecting to the database, create the following tables:

* `{{ app_name }}_{{ env }}`

## After initial configuration/deployment

### Update the app role only and/or update app configuration

Re-run the app/princex configuration role (will update configs and restart the services)

```bash
ansible-playbook app-update.yml -D --extra-vars "env=$ENV ansible_user=$ANSIBLE_USER"
```

### Update just the configurations (nginx, app) and restart the services if the files have changed

```bash
ansible-playbook app-update.yml -D --extra-vars "env=$ENV ansible_user=$ANSIBLE_USER" --tags="app-config,nginx-config"
ansible-playbook app-update.yml -D --extra-vars "env=$ENV ansible_user=$ANSIBLE_USER" --tags="app-config"
ansible-playbook app-update.yml -D --extra-vars "env=$ENV ansible_user=$ANSIBLE_USER" --tags="nginx-config"
```

### Check the version of the application code running on the app servers

```bash
ansible-playbook app-check-version.yml --extra-vars "env=$ENV ansible_user=$ANSIBLE_USER"
```

## Misc playbook

The `misc.yml` playbook is ignored from the git repo, so use this playbook for running miscellaneous tasks against multiple servers.

```bash
ansible-playbook misc.yml -D --extra-vars "env=$ENV ansible_user=$ANSIBLE_USER"
```

## Run `yum upgrade` on all machines for an environment and reboot

```bash
ansible-playbook all-yum-upgrade-reboot.yml --extra-vars "env=$ENV ansible_user=$ANSIBLE_USER"
```

## Manage DB users on Azure Postgres

This playbook is run against the bastion host to manage users in the PostgreSQL server. The `db_users` variable should be set in the `vault` variables file for the environment, since it will hold passwords. The `db_remove_users` variable can be set anywhere.

```bash
ansible-playbook db-manage-users.yml --extra-vars "env=$ENV ansible_user=$ANSIBLE_USER"
```

## Run `yum update` and reboot the instances

The `yum-update.yml` playbook will run `yum update` against all the instances in `$UPDATE_GROUP` 1 by 1 with a pause between hosts requiring confirmation to continue.

```bash
# export UPDATE_GROUP=bastion || app || princex || "" ("" == update all instances in env)

ansible-playbook -v -D yum-update.yml --extra-vars "env=$ENV ansible_user=$ANSIBLE_USER update_group=$UPDATE_GROUP"
```

## Configure `ops-elk` instance(s)

```bash
ansible-playbook -D ops-elk-configure.yml --extra-vars "env=ops ansible_user=$ANSIBLE_USER"

ansible-playbook -D ops-elk-update.yml --extra-vars "env=ops ansible_user=$ANSIBLE_USER"
```

## Configure `ops-monitoring` instance(s)

```bash
ansible-playbook -D ops-monitoring-configure.yml --extra-vars "env=ops ansible_user=$ANSIBLE_USER"

ansible-playbook -D ops-monitoring-update.yml --extra-vars "env=ops ansible_user=$ANSIBLE_USER"
```
