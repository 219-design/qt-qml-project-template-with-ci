#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
IFS=$'\n\t'

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${THISDIR}/utils.bash # will compute UTILS_WE_ARE_RUNNING_IN_CI

if [[ -n ${UTILS_WE_ARE_RUNNING_IN_CI-} ]];
# The '-' hyphen above tests without angering the 'set -u' about unbound variables
then
  echo "C.I. environment was detected."

  # Try various ways to print OS version info.
  # This lets us keep a record of this in our CI logs,
  # in case the CI docker images change.
  uname -a       || true
  lsb_release -a || true
  gcc --version  || true  # oddly, gcc often prints great OS information
  cat /etc/issue || true

  # What environment variables did the C.I. system set? Print them:
  env

  if [[ "$OSTYPE" != "cygwin" && "$OSTYPE" != "msys" ]]; then
    ${THISDIR}/../verify_authors.sh

    ${THISDIR}/linux_apt_get_qt_deps.sh
    ${THISDIR}/get_qt_libs.sh
  elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
    ${THISDIR}/provision_win.sh
  fi

else
  echo "Assuming we are NOT in cloud C.I. environment."
fi


THIS_FILENAME=$(basename "$0")
echo 'We assume this was run with '\''set -e'\'' (look at upper lines of this script).'
echo 'Assuming so, then getting here means:'
echo "${THIS_FILENAME} SUCCESS"
