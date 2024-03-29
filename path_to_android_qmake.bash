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

# Note: 25.1.8937393 is also known as Android NDK r25b.
# Qt 6.5.3 requires r25b, per:
#  https://wiki.qt.io/Qt_6.5_Tools_and_Versions#Software_configurations_for_Qt_6.5.3

export ANDROID_SDK_ROOT=$DL_FOLDER_ANDROID
export ANDROID_NDK_ROOT=$DL_FOLDER_ANDROID/ndk/25.1.8937393/

export PATH="$DL_FOLDER/Qt_desktop/6.5.3/android_armv7/bin/:$PATH"
