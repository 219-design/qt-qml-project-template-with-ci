#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

if [[ "$OSTYPE" != "darwin"* ]]; then
  echo "Whoops! This should only be executed on Mac OSX."
  exit -1
fi

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${THISDIR}/rootdirhelper.bash"

DL_FOLDER=$CUR_GUICODE_ROOT/dl_third_party

if [ -d $DL_FOLDER/Qt_desktop/5.15.0/clang_64/bin ]; then
    echo "no need to download qt5 for desktop"
else

  bash -x $CUR_GUICODE_ROOT/tools/ci/install-qt.sh \
   --directory $DL_FOLDER/Qt_desktop \
   --version 5.15.0 \
   qtbase \
   qtconnectivity \
   qtdeclarative \
   qtgraphicaleffects \
   qtimageformats \
   qtquickcontrols \
   qtquickcontrols2 \
   qtscript \
   qtsvg \
   qttools

  # we still need qt6 in order to execute qmlfmt.
  # TODO: update our qmlfmt binary so we can use Qt 6.5.3
  bash -x $CUR_GUICODE_ROOT/tools/ci/install-qt.sh \
   --directory $DL_FOLDER/Qt_desktop \
   --version 6.2.2 \
   qtbase \
   qtdeclarative \
   qt5compat

fi

if [ -d $DL_FOLDER/Qt_desktop/5.15.0/ios/bin ]; then
    echo "no need to download qt5 for ios"
else

  bash -x $CUR_GUICODE_ROOT/tools/ci/install-qt.sh \
   --directory $DL_FOLDER/Qt_desktop \
   --version 5.15.0 \
   --target ios \
   qtbase \
   qtconnectivity \
   qtdeclarative \
   qtgraphicaleffects \
   qtimageformats \
   qtquickcontrols \
   qtquickcontrols2 \
   qtsvg \
   qttools

  git checkout $CUR_GUICODE_ROOT/dl_third_party/Qt_desktop/5.15.0/ios/mkspecs/qconfig.pri

fi
