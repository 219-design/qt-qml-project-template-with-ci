#!/bin/bash

if [ "${BASH_SOURCE[0]}" -ef "$0" ]
then
    echo "Hey, you should source this script, not execute it!"
    exit 1
fi

NESTED_GUI_ROOT="" # Populate this if you move the qt-qml-project beneath git root
CUR_GIT_ROOT=$(git rev-parse --show-toplevel)

export CUR_GUICODE_ROOT="${CUR_GIT_ROOT}/${NESTED_GUI_ROOT}/"
