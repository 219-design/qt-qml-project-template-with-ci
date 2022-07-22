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
  MYAPP_EXTRA_CONF="CONFIG+=CONSOLE CONFIG+=debug_and_release"

  MSVCPATHFORBUILDING=$(cygpath -u "${VCToolsInstallDir}/bin/HOSTx64/x64")
  export PATH="${MSVCPATHFORBUILDING}:$PATH" # make sure MSVC link.exe is found (not bash/unix 'link' tool)
else
  qmakecmd=qmake
  makecmd=make
  MYAPP_EXTRA_CONF=""
  # adding this next line here (rather than in run_all_tests.sh), because we think
  # of the graph-generation as more of a "build" step than a "test":
  $DIR/sw_arch_doc/generate_graph.sh ${DIR}/src/ ${DIR}/

  # Next step done here (rather than inside generate_graph.sh) because the
  # graph script does not need to be "git aware".
  sw_arch_changed=$(git diff --exit-code ${DIR}/sw_arch_doc/all_src.dot || true)
  if [[ -z ${sw_arch_changed} ]]; then
      # What this block achieves is:
      #
      # If the '*.dot' file was not actually changed, then we FORCE the svg to
      # also be in an unchanged state.
      #
      # This solves a problem where the svg can always come up dirty if a
      # contributor is running the build script but the version of graphviz/dot
      # on that contributor's build machine is not an exact match for the
      # graphviz/dot version used by whoever caused the most recent changes in
      # sw_arch_doc/.
      git checkout ${DIR}/sw_arch_doc/all_src.svg
  fi
fi

if [[ -n ${MYAPP_TEMPLATE_QT6-} ]]; then
  # Strip out usage of QML 'import QtGraphicalEffects' on Qt 6.
  # Effects have moved to 'import QtQuick3D.Effects' and we have not
  # yet made that available in our CI job.
  git apply $DIR/tools/ci/strip_effects_for_sake_of_qt6.patch
fi

$DIR/tools/ci/version.sh

source $DIR/path_to_qmake.bash

mkdir -p build
pushd build >& /dev/null

  # When you need release: CONFIG+=release
  ${qmakecmd} $MYAPP_EXTRA_CONF CONFIG+=force_debug_info "$DIR" # note: debug INFO (symbols) are ok even in release

  ${makecmd}

  ${makecmd} install # puts necessary items side-by-side with app exe

  if [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
    ${makecmd} debug
  fi

popd >& /dev/null

if [[ -n ${MYAPP_TEMPLATE_BUILD_ANDROID-} ]]; then
  tools/ci/get_android_toolchain.sh
  tools/ci/build_android_app.sh build/for_android "CONFIG+=force_debug_info"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  pushd build/src/app >& /dev/null
    macdeployqt app.app        -no-strip -libpath=$PWD -qmldir=../../../src/
    macdeployqt lib_tests.app  -no-strip -libpath=$PWD -qmldir=../../../src/
    macdeployqt util_tests.app -no-strip -libpath=$PWD -qmldir=../../../src/
  popd >& /dev/null

  ./build_ios_app.sh
fi

windows_deploy () {
  FLAVOR="$1"
  EXEDIR="$2"
  PDIR="$3"
  SHIPDIR="$4"
  mkdir -p ${SHIPDIR}
  cp ${EXEDIR}/*.exe ${SHIPDIR}  # copy main and tests. tests must be side-by-side with Qt DLL(s), too.
  cp ${PDIR}/libstylesplugin.dll ${SHIPDIR}

  pushd ${SHIPDIR} >& /dev/null
    # Technically, we should set qmldir to our own 'src' dir, to allow
    # windeployqt to deploy the MINIMUM necessary QML support files. However,
    # this is a popular workaround for various bugs and annoyances -- by
    # pointing qmldir to the Qt framework install dir itself, we just deploy ALL
    # qml-related support files that Qt offers.
    windeployqt "${FLAVOR}" --qmldir "${WINALLQML}"  app.exe
  popd >& /dev/null
}

if [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
  EXEDIR=build/src/app/release
  PLUGINDIR=build/src/libstyles/release
  SHIPDIR=build/windeployfolder

  EXEDIRDBG=build/src/app/debug
  PLUGINDIRDBG=build/src/libstyles/debug
  SHIPDIRDBG=build/windeployfolder_debug

  windows_deploy "--release" ${EXEDIR} ${PLUGINDIR} ${SHIPDIR}
  windows_deploy "--debug" ${EXEDIRDBG} ${PLUGINDIRDBG} ${SHIPDIRDBG}
fi
