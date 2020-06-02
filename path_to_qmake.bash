#!/bin/bash

if [ "${BASH_SOURCE[0]}" -ef "$0" ]
then
    echo "Hey, you should source this script, not execute it!"
    exit 1
fi

CUR_GIT_ROOT=$(git rev-parse --show-toplevel)

DL_FOLDER=$CUR_GIT_ROOT/dl_third_party

if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="$DL_FOLDER/Qt_desktop/5.15.0/clang_64/bin/:$PATH"
else
  export PATH="$DL_FOLDER/Qt_desktop/5.15.0/gcc_64/bin/:$PATH"
fi
