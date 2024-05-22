#!/bin/bash

if [ "${BASH_SOURCE[0]}" -ef "$0" ]
then
    echo "Hey, you should source this script, not execute it!"
    exit 1
fi

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${THISDIR}/tools/ci/rootdirhelper.bash"

DL_FOLDER=$CUR_GUICODE_ROOT/dl_third_party

export PATH="$DL_FOLDER/Qt_desktop/6.5.3/ios/bin/:$PATH"
