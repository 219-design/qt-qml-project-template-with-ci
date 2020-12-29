#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

CUR_GIT_ROOT=$(git rev-parse --show-toplevel)

DL_FOLDER=$CUR_GIT_ROOT/dl_third_party
DL_FOLDER_ANDROID=$DL_FOLDER/android_kits

mkdir -p $DL_FOLDER_ANDROID

if [ -d $DL_FOLDER/Qt/5.15.0/android/bin ]; then
    echo "no need to download qt5"
else

  bash -x $CUR_GIT_ROOT/tools/ci/install-qt.sh \
   --directory $DL_FOLDER/Qt \
   --version 5.15.0 \
   --target android \
   --toolchain any \
   qtandroidextras \
   qtbase \
   qtconnectivity \
   qtdeclarative \
   qtgraphicaleffects \
   qtimageformats \
   qtquickcontrols \
   qtquickcontrols2 \
   qtsvg \
   qttools

fi

if [ -f $DL_FOLDER_ANDROID/commandlinetools-linux-6200805_latest.zip ]; then
  echo "no need to download android commandlinetools"
else
  $CUR_GIT_ROOT/tools/ci/install_android_kits.sh
fi
