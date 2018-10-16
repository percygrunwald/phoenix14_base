#!/usr/bin/env bash
#
# ## Requirements
#   * git
#
# ## Usage:
#   $ ./new_project.sh project_name ProjectName

ORIGINAL_APP_NAME_UNDERSCORE=phoenix14_base
ORIGINAL_APP_NAME_MODULE=Phoenix14Base
ORIGINAL_APP_NAME_HYPHEN=phoenix14-base

APP_NAME_UNDERSCORE=$1
APP_NAME_MODULE=$2

if [[ -z $APP_NAME_UNDERSCORE || -z $APP_NAME_MODULE ]]
  then
    cat <<EOF
Error: arguments are missing!

Example:

  $ ./new_project.sh project_name ProjectName

EOF
    exit 1
fi

APP_NAME_HYPHEN=$(echo $APP_NAME_UNDERSCORE | sed 's/_/-/')

echo "APP_NAME_UNDERSCORE=$APP_NAME_UNDERSCORE"
echo "APP_NAME_MODULE=$APP_NAME_MODULE"
echo "APP_NAME_HYPHEN=$APP_NAME_HYPHEN"

EXCLUDES=(--exclude-dir=_build --exclude-dir=node_modules --exclude-dir=deps --exclude-dir='*/.*' --exclude=new_project.sh)

echo "Replacing instances in files of \"$ORIGINAL_APP_NAME_UNDERSCORE\" with \"$APP_NAME_UNDERSCORE\"..."
grep -r ${EXCLUDES[@]} $ORIGINAL_APP_NAME_UNDERSCORE .

echo ""
echo "Replacing instances in files of \"$ORIGINAL_APP_NAME_MODULE\" with \"$APP_NAME_MODULE\"..."
grep -r ${EXCLUDES[@]} $ORIGINAL_APP_NAME_MODULE .

echo ""
echo "Replacing instances in files of \"$ORIGINAL_APP_NAME_HYPHEN\" with \"$APP_NAME_HYPHEN\"..."
grep -r ${EXCLUDES[@]} $ORIGINAL_APP_NAME_HYPHEN .

echo ""
echo "Replacing instances in dirnames of \"$ORIGINAL_APP_NAME_UNDERSCORE\" with \"$APP_NAME_UNDERSCORE\"..."
find . -type d -name "*$ORIGINAL_APP_NAME_UNDERSCORE*" ! -path "*/.*" ! -path "./_build*"
