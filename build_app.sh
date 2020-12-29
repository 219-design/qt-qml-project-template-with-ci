#!/bin/bash

#
# Copyright (c) 2020, 219 Design, LLC
# See LICENSE.txt
#
# https://www.219design.com
# Software | Electrical | Mechanical | Product Design
#

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

pushd .
trap "popd" EXIT HUP INT QUIT TERM

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR  # enter this script's directory. (in case called from root of repository)

$DIR/tools/ci/version.sh

source $DIR/path_to_qmake.bash

pushd build >& /dev/null

  # When you need release: CONFIG+=release
  qmake CONFIG+=force_debug_info "$DIR" # note: debug INFO (symbols) are ok even in release

  make

  make install # puts necessary items side-by-side with app exe

popd >& /dev/null

if [[ -n ${MYAPP_TEMPLATE_BUILD_ANDROID-} ]]; then
  tools/ci/get_android_toolchain.sh
  tools/ci/build_android_app.sh build/for_android "CONFIG+=force_debug_info"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  pushd build/src/app >& /dev/null
    macdeployqt app.app -no-strip -libpath=$PWD -qmldir=../../../src/
    macdeployqt lib_tests.app -no-strip -libpath=$PWD -qmldir=../../../src/
  popd >& /dev/null

  ./build_ios_app.sh
fi
