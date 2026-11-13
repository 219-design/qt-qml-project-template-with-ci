#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
IFS=$'\n\t'

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck disable=SC1091 # rootdirhelper.bash was not specified as input
source "${THISDIR}/rootdirhelper.bash"

cd "$DL_FOLDER"

target_file=shellcheck-v0.11.0.linux.x86_64.tar.gz

if [ -f "${DL_FOLDER}/${target_file}" ]; then
  echo "no need to download $target_file"
else
  wget https://github.com/koalaman/shellcheck/releases/download/v0.11.0/"$target_file"

  # verify the checksum
  echo "$(cat "${THISDIR}/get_shellcheck.sha256") $target_file" | sha256sum --check

  tar -xvzf shellcheck-v0.11.0.linux.x86_64.tar.gz

fi


THIS_FILENAME=$(basename "$0")
echo 'We assume this was run with '\''set -e'\'' (look at upper lines of this script).'
echo 'Assuming so, then getting here means:'
echo "${THIS_FILENAME} SUCCESS"
