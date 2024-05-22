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

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${DIR}/../ci/rootdirhelper.bash"

if [[ -n ${MYAPP_TEMPLATE_PREFER_QMAKE-} ]]; then
  APP_TO_LAUNCH=${CUR_GUICODE_ROOT}/build/src/app/app
  #if [[ "$OSTYPE" == "darwin"* ]]; then
  #fi
else
  APP_TO_LAUNCH=${CUR_GUICODE_ROOT}/cbuild/stage/app
fi

cd $CUR_GUICODE_ROOT
rm -f gui_test.log # in C.I. there should never be a leftover file. but perhaps locally.

if [[ -n ${BITBUCKET_REPO_OWNER-} ]]; then
  ${APP_TO_LAUNCH} -g 2>&1 | tee gui_test.log
elif [[ "$OSTYPE" != "darwin"* ]]; then
    # "run, bt, run" is a workaround for a gdb behavior change between gdb 8 and gdb 9
    # for more info, see: https://sourceware.org/bugzilla/show_bug.cgi?id=27125
    gdb -n -batch -return-child-result -ex "set args -g -v" -ex "run" -ex "bt" -ex "run" ${APP_TO_LAUNCH} 2>&1 | tee gui_test.log
else
  build/src/app/app.app/Contents/MacOS/app -g 2>&1 | tee gui_test.log
fi

tools/gui_test/check_gui_test_log.py gui_test.log
rm -f gui_test.log

echo 'We assume this was run with '\''set -e'\'' (look at upper lines of this script).'
echo 'Assuming so, then getting here means:'
echo 'launch_gui_for_display SUCCESS'
