#!/bin/bash

#
# Copyright (c) 2020, 219 Design, LLC
# See LICENSE.txt
#
# https://www.219design.com
# Software | Electrical | Mechanical | Product Design
#

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${THISDIR}/../ci/rootdirhelper.bash"

source "${CUR_GUICODE_ROOT}/tools/ci/utils.bash" # for terminal colorization

run_a_test() {
  while read filenames; do
    for fl in "$filenames"; do
      $fl
    done
  done
}

cd $CUR_GUICODE_ROOT

if [[ -n ${MYAPP_TEMPLATE_PREFER_QMAKE-} ]]; then
  OUR_TEST_BINARIES_DIR=build/src/app
  if [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
    OUR_TEST_BINARIES_DIR=build/windeployfolder
  fi
else
  OUR_TEST_BINARIES_DIR=cbuild/stage
  if [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
    OUR_TEST_BINARIES_DIR=cbuild/windeployfolder_debug
  fi
fi

# run all test binaries that got built in the expected dir:
find "${OUR_TEST_BINARIES_DIR}" -type f \( -name '*test' -o -name '*tests' -o -name '*test.exe' -o -name '*tests.exe' \) | run_a_test

echo 'We assume this was run with '\''set -e'\'' (look at upper lines of this script).'
echo 'Assuming so, then getting here means:'
echo "${u_green}run_cpp_auto_tests SUCCESS${u_resetcolor}"
