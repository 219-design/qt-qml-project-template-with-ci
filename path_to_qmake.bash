#!/bin/bash

if [ "${BASH_SOURCE[0]}" -ef "$0" ]
then
    echo "Hey, you should source this script, not execute it!"
    exit 1
fi

CUR_GIT_ROOT=$(git rev-parse --show-toplevel)

# set qt5 path to the submodule contents
PATH="$CUR_GIT_ROOT/build_qt_binaries/qt5_opt_install/bin:$PATH"
# comment out next line if you wish to prefer 'opt' in place of 'dbg':
PATH="$CUR_GIT_ROOT/build_qt_binaries/qt5_dbg_install/bin:$PATH"
