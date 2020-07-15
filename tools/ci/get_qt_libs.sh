#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

CUR_GIT_ROOT=$(git rev-parse --show-toplevel)

DL_FOLDER=$CUR_GIT_ROOT/dl_third_party

if [ -d $DL_FOLDER/Qt_desktop/5.15.0/gcc_64/bin ]; then
    echo "no need to download qt5 for desktop"
else

  bash -x $CUR_GIT_ROOT/tools/ci/install-qt.sh \
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

  if [[ "$OSTYPE" == "darwin"* ]]; then
    bash -x $CUR_GIT_ROOT/tools/ci/install-qt.sh \
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

    git checkout $CUR_GIT_ROOT/dl_third_party/Qt_desktop/5.15.0/ios/mkspecs/qconfig.pri
  fi

fi
