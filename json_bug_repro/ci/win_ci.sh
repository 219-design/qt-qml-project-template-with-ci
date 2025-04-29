#!/bin/bash

set -Eeuo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
IFS=$'\n\t'

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CUR_GIT_ROOT=$(git rev-parse --show-toplevel)

if [[ "$OSTYPE" != "cygwin" && "$OSTYPE" != "msys" ]]; then
  echo "This script is for use on Microsoft Windows"
  exit 1
fi

if [[ -z ${VCToolsInstallDir-} ]]; then
  echo "WHOOPS. vcvars64 (or vcvarsall) was not called yet."
  echo "You MUST start a VISUAL STUDIO command prompt. (Then start git-bash from within it.)"
  echo "Read the above and try again."
  exit 1
fi


"${THISDIR}"/qtapps/ci.sh

source "${THISDIR}"/qtapps/rootdirhelper.bash

MSVCPATHFORBUILDING=$(cygpath -u "${VCToolsInstallDir}/bin/HOSTx64/x64")
export PATH="${MSVCPATHFORBUILDING}:$PATH" # make sure MSVC link.exe is found (not bash/unix 'link' tool)

WINDLPATH=$(cygpath -u $DL_FOLDER)

# Variables used by CMakeLists
export Qt6_DIR="${WINDLPATH}/Qt_desktop/6.5.3/msvc2019_64/lib/cmake/Qt6/"

# Put qmake on the PATH:
export PATH="${WINDLPATH}/Qt_desktop/6.5.3/msvc2019_64/bin:$PATH"



mkdir -p cbuild
pushd cbuild

  cmake "-G" "NMake Makefiles" -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON $THISDIR/..

  # See: https://forum.qt.io/topic/146961/building-qt6-5-with-nmake-error
  # Workaround for bug in Qt6CoreMacros.cmake:
  #buggy_genfile=meta_types/qt6appreproducejsonbug_debug_metatypes.json
  #if [ ! -s "$buggy_genfile" ]; then
  #  echo "{}" >> "$buggy_genfile"
  #fi

  nmake


popd # pushd cbuild



THIS_FILENAME=$(basename "$0")
echo 'We assume this was run with '\''set -e'\'' (look at upper lines of this script).'
echo 'Assuming so, then getting here means:'
echo "${THIS_FILENAME} SUCCESS"
