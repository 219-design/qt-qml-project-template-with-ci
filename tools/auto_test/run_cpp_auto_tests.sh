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
CUR_GIT_ROOT=$(git rev-parse --show-toplevel)

run_a_test() {
  while read filenames; do
    for fl in "$filenames"; do
      $fl
    done
  done
}

cd $CUR_GIT_ROOT

OUR_TEST_BINARIES_DIR=build/src/app
if [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
  OUR_TEST_BINARIES_DIR=build/windeployfolder
fi

# run all test binaries that got built in the expected dir:
find "${OUR_TEST_BINARIES_DIR}" -type f \( -name '*test' -o -name '*tests' -o -name '*test.exe' -o -name '*tests.exe' \) | run_a_test

echo 'We assume this was run with '\''set -e'\'' (look at upper lines of this script).'
echo 'Assuming so, then getting here means:'
echo 'run_cpp_auto_tests SUCCESS'
