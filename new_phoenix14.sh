#!/usr/bin/env bash
#
# ## Requirements
#   * git
#
# ## Usage:
#   $ ./new_phoenix14.sh project_name ProjectName

REPO_URL=https://github.com/pgrunwald/phoenix14_base
ORIGINAL_APP_NAME_UNDERSCORE=phoenix14_base
ORIGINAL_APP_NAME_MODULE=Phoenix14Base
ORIGINAL_APP_NAME_HYPHEN=phoenix14-base
ORIGINAL_APP_NAME_ALPHA=phoenix14base

APP_NAME_UNDERSCORE=$1
APP_NAME_MODULE=$2

if [[ -z $APP_NAME_UNDERSCORE || -z $APP_NAME_MODULE ]]
  then
    cat <<EOF
Error: arguments are missing!

Example:

    $ ./new_phoenix14.sh project_name ProjectName

EOF
    exit 1
fi

APP_NAME_HYPHEN=$(echo $APP_NAME_UNDERSCORE | sed 's/_/-/')
APP_NAME_ALPHA=$(echo $APP_NAME_UNDERSCORE | sed 's/_//')

EXCLUDES=(--exclude-dir=_build --exclude-dir=node_modules --exclude-dir=deps --exclude-dir='*/.*' --exclude=new_phoenix14.sh)

echo "Cloning $REPO_URL to $APP_NAME_UNDERSCORE/..."
git clone $REPO_URL $APP_NAME_UNDERSCORE
rm -rf $APP_NAME_UNDERSCORE/.git
rm -f $APP_NAME_UNDERSCORE/LICENSE $APP_NAME_UNDERSCORE/new_phoenix14.sh

# Change to new directory
cd $APP_NAME_UNDERSCORE

# Reinitialize git repo
git init

echo "Replacing instances in files of \"$ORIGINAL_APP_NAME_UNDERSCORE\" with \"$APP_NAME_UNDERSCORE\"..."
grep -rl ${EXCLUDES[@]} $ORIGINAL_APP_NAME_UNDERSCORE . | xargs sed -i "" "s/$ORIGINAL_APP_NAME_UNDERSCORE/$APP_NAME_UNDERSCORE/g"

echo ""
echo "Replacing instances in files of \"$ORIGINAL_APP_NAME_MODULE\" with \"$APP_NAME_MODULE\"..."
grep -rl ${EXCLUDES[@]} $ORIGINAL_APP_NAME_MODULE . | xargs sed -i "" "s/$ORIGINAL_APP_NAME_MODULE/$APP_NAME_MODULE/g"

echo ""
echo "Replacing instances in files of \"$ORIGINAL_APP_NAME_HYPHEN\" with \"$APP_NAME_HYPHEN\"..."
grep -rl ${EXCLUDES[@]} $ORIGINAL_APP_NAME_HYPHEN . | xargs sed -i "" "s/$ORIGINAL_APP_NAME_HYPHEN/$APP_NAME_HYPHEN/g"

echo ""
echo "Replacing instances in files of \"$ORIGINAL_APP_NAME_ALPHA\" with \"$APP_NAME_ALPHA\"..."
grep -rl ${EXCLUDES[@]} $ORIGINAL_APP_NAME_ALPHA . | xargs sed -i "" "s/$ORIGINAL_APP_NAME_ALPHA/$APP_NAME_ALPHA/g"

echo ""
echo "Renaming dirs by replacing \"$ORIGINAL_APP_NAME_UNDERSCORE\" with \"$APP_NAME_UNDERSCORE\"..."
DIRS_TO_RENAME=$(find . -type d -name "*$ORIGINAL_APP_NAME_UNDERSCORE*" ! -path "*/.*" ! -path "./_build*")

for dir in $DIRS_TO_RENAME; do
  new_dir_name=$(echo $dir | sed "s/$ORIGINAL_APP_NAME_UNDERSCORE/$APP_NAME_UNDERSCORE/g")
  mv $dir $new_dir_name
done

echo ""
echo "Renaming files by replacing \"$ORIGINAL_APP_NAME_UNDERSCORE\" with \"$APP_NAME_UNDERSCORE\"..."
FILES_TO_RENAME=$(find . -type f -name "*$ORIGINAL_APP_NAME_UNDERSCORE*" ! -path "*/.*" ! -path "./_build*")

for file in $FILES_TO_RENAME; do
  new_file_name=$(echo $file | sed "s/$ORIGINAL_APP_NAME_UNDERSCORE/$APP_NAME_UNDERSCORE/g")
  mv $file $new_file_name
done

echo ""
echo "Creating files from *.sample..."
SAMPLES_TO_COPY=$(find . -type f -name "*.sample" ! -path "*.git*")

for sample_file_name in $SAMPLES_TO_COPY; do
  new_file_name=$(echo $sample_file_name | sed "s/\.sample//g")
  echo "Created $new_file_name"
  cp $sample_file_name $new_file_name
done

cat <<"EOF"

Done! Please edit the files above (or at least the files in ./config) to match your settings and you're ready to go.

You will also need to create an Ansible vault key and `prod.vault.yml` file:

    $ pwgen 64 | head > ansible/vault.key
    $ (cd ansible && ansible-vault create vars/prod.vault.yml)

You should enter the following YAML data into your `prod.vault.yml` at a minimum (replace `...` with a strong random string 64 characters long):

    # ansible/vars/prod.vault.yml
    ---
    erlang_distribution_protocol_cookie: "..."
    db_password: "..."
    secret_key_base: "..."

    deploy_keys: []

**After editing the config files**, you can test your new application by running:

    # Install all the deps and setup the DB
    $ mix deps.get && (cd assets && npm install) && mix ecto.setup

    # Run the server
    $ mix phx.server

EOF
