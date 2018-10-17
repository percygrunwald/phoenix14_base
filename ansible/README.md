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

### Deploy application code to app instances

**Make sure to edit `app-deploy.yml` with the correct variables for your app! (usually just repo and branch should be fine)**

#### Generating deploy keys for private git repos

Unless your repo is public, you will need to configure your hosted Git project with a deploy key, which allows your server(s) to pull your code from your git repo. These are the steps you will need to do:

1. Generate an RSA keypair with `ssh-keygen -t rsa -b 4096 -f $KEY_NAME`
2. Add the **private key** to your `vars/{{ env }}.vault.yml`

```yaml
# e.g. vars/prov.vault.yml
deploy_keys:
  - name: phoenix14-base-prod-app
    key: |
      -----BEGIN RSA PRIVATE KEY-----
      ...
      -----END RSA PRIVATE KEY-----
```

3. Add the **public key** to your Git hosting (in Gitlab, it's under `repo > Settings > Repository > Deploy Keys`)
4. Update your `app-deploy.yml` playbook to include your `deploy_key_name`:

```yaml
...
      deploy_key_name: "phoenix14-base-{{ env }}-app"
...
```

#### Deployment

```bash
ansible-playbook app-deploy.yml --extra-vars "env=$ENV ansible_user=$ANSIBLE_USER"
```

If upgrading/downgrading Erlang/Elixir/deps, you may want to clean the deps and `_build` dir:

```bash
ansible-playbook app-deploy.yml --extra-vars "env=$ENV ansible_user=$ANSIBLE_USER elixir_clean_deps=true elixir_clean_build=true"
```

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

## Run `yum update` and reboot the instances

The `yum-update.yml` playbook will run `yum update` against all the instances in `$UPDATE_GROUP` 1 by 1 with a pause between hosts requiring confirmation to continue.

```bash
# export UPDATE_GROUP=bastion || app || princex || "" ("" == update all instances in env)

ansible-playbook -v -D yum-update.yml --extra-vars "env=$ENV ansible_user=$ANSIBLE_USER update_group=$UPDATE_GROUP"
```
