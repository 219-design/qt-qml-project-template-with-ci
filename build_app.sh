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

if [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
  if [[ -z ${VCToolsInstallDir-} ]]; then
    echo "WHOOPS. vcvars64 (or vcvarsall) was not called yet."
    echo "You MUST start a VISUAL STUDIO command prompt. (Then start git-bash from within it.)"
    echo "Read the above and try again."
    exit 1
  fi

  qmakecmd=qmake.exe
  makecmd=nmake
  MYAPP_EXTRA_CONF="CONFIG+=CONSOLE"

  MSVCPATHFORBUILDING=$(cygpath -u "${VCToolsInstallDir}/bin/HOSTx64/x64")
  export PATH="${MSVCPATHFORBUILDING}:$PATH" # make sure MSVC link.exe is found (not bash/unix 'link' tool)
else
  qmakecmd=qmake
  makecmd=make
  MYAPP_EXTRA_CONF=""
  # adding this next line here (rather than in run_all_tests.sh), because we think
  # of the graph-generation as more of a "build" step than a "test":
  $DIR/sw_arch_doc/generate_graph.sh
fi

$DIR/tools/ci/version.sh

source $DIR/path_to_qmake.bash

pushd build >& /dev/null

  # When you need release: CONFIG+=release
  ${qmakecmd} $MYAPP_EXTRA_CONF CONFIG+=force_debug_info "$DIR" # note: debug INFO (symbols) are ok even in release

  ${makecmd}

  ${makecmd} install # puts necessary items side-by-side with app exe

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

if [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
  EXEDIR=build/src/app/release
  SHIPDIR=build/windeployfolder
  mkdir -p ${SHIPDIR}
  cp ${EXEDIR}/app.exe ${SHIPDIR}
  cp ${EXEDIR}/libstylesplugin.dll ${SHIPDIR}

  pushd ${SHIPDIR} >& /dev/null
    # Technically, we should set qmldir to our own 'src' dir, to allow
    # windeployqt to deploy the MINIMUM necessary QML support files. However,
    # this is a popular workaround for various bugs and annoyances -- by
    # pointing qmldir to the Qt framework install dir itself, we just deploy ALL
    # qml-related support files that Qt offers.
    windeployqt --release --qmldir "${WINALLQML}"  app.exe
  popd >& /dev/null
fi
