#!/bin/bash

#
# Copyright (c) 2020, 219 Design, LLC
# See LICENSE.txt
#
# https://www.219design.com
# Software | Electrical | Mechanical | Product Design
#

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

echo "reading single argument (should be :0 or :N to choose your X display)"
DISPLAY_ID=$1

CUR_GIT_ROOT=$(git rev-parse --show-toplevel)

cd $CUR_GIT_ROOT
./install_linux.sh # build the AppImage folder structure

if [[ -n ${GITHUB_ACTIONS-} || -n ${BITBUCKET_REPO_OWNER-} || -n ${BITBUCKET_REPO_FULL_NAME-} ]];
# The '-' hyphens above test without angering the 'set -u' about unbound variables
then
  echo "Assuming C.I. environment."
  echo "Deleting various binaries except for AppImage (to prove AppImage works)"
  rm -rf build # highly destructive! we want to prove the AppImage is standalone
  rm -rf build_qt_binaries # highly destructive! we want to prove the AppImage is standalone
fi

# bitbucket CANNOT tolerate sudo
WITHSUDO=""
if [[ -n ${GITHUB_ACTIONS-} ]];
then
   # github REQUIRES it
   WITHSUDO="sudo"
fi

if [ ${DISPLAY_ID} = ":0" ]; then
  echo "assuming there is NOT a need for Xvfb"
else
  $WITHSUDO Xvfb ${DISPLAY_ID} -screen 0 1024x768x16 &
  VIRT_FB_PID=$!
  sleep 4 # time to (probabilistically) ensure that Xvfb has started
fi

cd $CUR_GIT_ROOT
rm -f gui_test.log # in C.I. there should never be a leftover file. but perhaps locally.

# -g flag causes app to close when test is done:
DISPLAY=${DISPLAY_ID} AppImage_staging/usr/bin/app -g 2>&1 |& tee gui_test.log

tools/gui_test/check_gui_test_log.py gui_test.log
rm -f gui_test.log

if [ ${DISPLAY_ID} = ":0" ]; then
  echo "we didn't launch Xvfb, so we don't try to kill it"
else
  $WITHSUDO kill $VIRT_FB_PID || true
fi

echo 'We assume this was run with '\''set -x'\'' (look at upper lines of this script).'
echo 'Assuming so, then getting here means:'
echo 'test_AppImage SUCCESS'
