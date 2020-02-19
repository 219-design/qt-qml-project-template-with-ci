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
DISPLAY=${DISPLAY_ID} build/src/app/app -g 2>&1 |& tee gui_test.log

tools/gui_test/check_gui_test_log.py gui_test.log
rm -f gui_test.log

if [ ${DISPLAY_ID} = ":0" ]; then
  echo "we didn't launch Xvfb, so we don't try to kill it"
else
  $WITHSUDO kill $VIRT_FB_PID
fi

echo 'We assume this was run with '\''set -x'\'' (look at upper lines of this script).'
echo 'Assuming so, then getting here means:'
echo 'launch_gui_for_display SUCCESS'
