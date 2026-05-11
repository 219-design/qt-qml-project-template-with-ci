#!/bin/bash

if [ "${BASH_SOURCE[0]}" -ef "$0" ]
then
    echo "Hey, you should source this script, not execute it!"
    exit 1
fi

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck disable=SC1091 # rootdirhelper.bash was not specified as input
source "${THISDIR}/tools/ci/rootdirhelper.bash"

DL_FOLDER_ANDROID=$DL_FOLDER/android_kits

# Note: 27.2.12479018 is also known as Android NDK r27c.
# Qt 6.10.2 requires r27c, per:
#  https://wiki.qt.io/Qt_6.10_Tools_and_Versions#Software_configurations_for_Qt_6.10.2

export ANDROID_SDK_ROOT=$DL_FOLDER_ANDROID
export ANDROID_NDK_ROOT=$DL_FOLDER_ANDROID/ndk/27.2.12479018/

export PATH="$DL_FOLDER/Qt_desktop/6.10.2/android_armv7/bin/:$PATH"
