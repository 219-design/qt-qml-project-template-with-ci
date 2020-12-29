#!/bin/bash

#
# Copyright (c) 2020, 219 Design, LLC
# See LICENSE.txt
#
# https://www.219design.com
# Software | Electrical | Mechanical | Product Design
#

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

if [[ "$OSTYPE" != "darwin"* ]]; then
  echo "reading single argument (should be either empty or ':1' to choose display)"
  export DISPLAY="${1:-"$DISPLAY"}"
fi

CUR_GIT_ROOT=$(git rev-parse --show-toplevel)

cd $CUR_GIT_ROOT
rm -f gui_test.log # in C.I. there should never be a leftover file. but perhaps locally.

if [[ -n ${BITBUCKET_REPO_OWNER-} ]]; then
  ${CUR_GIT_ROOT}/build/src/app/app -g 2>&1 | tee gui_test.log
 elif [[ "$OSTYPE" != "darwin"* ]]; then
   gdb -n -batch -return-child-result -ex "set args -g -v" -ex "run" -ex "bt" ${CUR_GIT_ROOT}/build/src/app/app 2>&1 | tee gui_test.log
else
  build/src/app/app.app/Contents/MacOS/app -g 2>&1 | tee gui_test.log
fi

tools/gui_test/check_gui_test_log.py gui_test.log
rm -f gui_test.log

echo 'We assume this was run with '\''set -x'\'' (look at upper lines of this script).'
echo 'Assuming so, then getting here means:'
echo 'launch_gui_for_display SUCCESS'
