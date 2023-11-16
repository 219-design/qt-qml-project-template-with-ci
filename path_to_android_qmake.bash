#!/bin/bash

if [ "${BASH_SOURCE[0]}" -ef "$0" ]
then
    echo "Hey, you should source this script, not execute it!"
    exit 1
fi

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${THISDIR}/tools/ci/rootdirhelper.bash"

DL_FOLDER=$CUR_GUICODE_ROOT/dl_third_party
DL_FOLDER_ANDROID=$DL_FOLDER/android_kits

export ANDROID_SDK_ROOT=$DL_FOLDER_ANDROID
export ANDROID_NDK_ROOT=$DL_FOLDER_ANDROID/ndk-bundle

export PATH="$DL_FOLDER/Qt/5.15.0/android/bin/:$PATH"
