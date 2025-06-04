#!/bin/bash

#
# Copyright (c) 2020, 219 Design, LLC
# See LICENSE.txt
#
# https://www.219design.com
# Software | Electrical | Mechanical | Product Design
#

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

echo "reading single argument (should be either empty or ':1' to choose display)"
export DISPLAY="${1:-"$DISPLAY"}"

CUR_GIT_ROOT=$(git rev-parse --show-toplevel)

cd $CUR_GIT_ROOT
./install_linux.sh # build the AppImage folder structure

if [[ -n ${GITHUB_ACTIONS-} || -n ${BITBUCKET_REPO_OWNER-} || -n ${BITBUCKET_REPO_FULL_NAME-} ]];
# The '-' hyphens above test without angering the 'set -u' about unbound variables
then
  echo "Assuming C.I. environment."
  echo "Deleting various binaries except for AppImage (to prove AppImage works)"
  rm -rf build # highly destructive! we want to prove the AppImage is standalone
  rm -rf dl_third_party # highly destructive! we want to prove the AppImage is standalone
fi

cd $CUR_GIT_ROOT
rm -f gui_test.log # in C.I. there should never be a leftover file. but perhaps locally.

# -g flag causes app to close when test is done:
LD_LIBRARY_PATH=$PWD/AppImage_staging/usr/lib AppImage_staging/usr/bin/app -g -v 2>&1 |& tee gui_test.log # TODO: remove LD_LIBRARY_PATH
# TODO: remove LD_LIBRARY_PATH on above line. linuxdeployqt _should_ render it unnecessary.
#    (don't have time to research now, but linuxdeployqt may have a bug)

tools/gui_test/check_gui_test_log.py gui_test.log
rm -f gui_test.log

echo 'We assume this was run with '\''set -e'\'' (look at upper lines of this script).'
echo 'Assuming so, then getting here means:'
echo 'test_AppImage SUCCESS'
