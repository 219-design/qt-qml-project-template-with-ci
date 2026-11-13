#!/bin/bash

if [ "${BASH_SOURCE[0]}" -ef "$0" ]
then
    echo "Hey, you should source this script, not execute it!"
    exit 1
fi

NESTED_GUI_ROOT="" # Populate this if you move the qt-qml-project beneath git root
CUR_GIT_ROOT=$(git rev-parse --show-toplevel)

export CUR_GUICODE_ROOT="${CUR_GIT_ROOT}/${NESTED_GUI_ROOT}/"

DL_FOLDER=$CUR_GUICODE_ROOT/dl_third_party
if [[ -n ${MYAPP_TEMPLATE_DL_FOLDER_OVERRIDE-} ]]; then
  DL_FOLDER=${MYAPP_TEMPLATE_DL_FOLDER_OVERRIDE}
fi

if [[ -n ${MYAPP_TEMPLATE_PREFER_QMAKE-} ]]; then
  # for legacy qmake builds
  BUILDOUT_DBG="${CUR_GIT_ROOT}"/build
  BUILDOUT_OPT="${CUR_GIT_ROOT}"/build_Release
else
  # CMake builds
  BUILDOUT_DBG="${CUR_GIT_ROOT}"/cbuild_Debug
  BUILDOUT_OPT="${CUR_GIT_ROOT}"/cbuild_Release
fi

CLANG_COVERAGE_DATA_DIR="${BUILDOUT_DBG}/coverage_data/"


export CUR_GIT_ROOT
export CUR_GUICODE_ROOT
export DL_FOLDER
export BUILDOUT_DBG
export BUILDOUT_OPT
export CLANG_COVERAGE_DATA_DIR
