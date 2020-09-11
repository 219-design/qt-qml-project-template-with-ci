#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Whoops! There is a SEPARATE script for Mac OSX. This one is linux-specific."
  exit -1
fi

CUR_GIT_ROOT=$(git rev-parse --show-toplevel)

DL_FOLDER=$CUR_GIT_ROOT/dl_third_party

sudo pip3 install aqtinstall  # https://github.com/miurahr/aqtinstall

if [ -d $DL_FOLDER/Qt_desktop/5.15.0/gcc_64/bin ]; then
    echo "no need to download qt5 for desktop"
else

  # https://github.com/miurahr/aqtinstall/issues/126 "Installing smaller subset of the libraries"
  python3 -m aqt install --outputdir $DL_FOLDER/Qt_desktop 5.15.0 linux desktop --archives \
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

# A fix for: error while loading shared libraries: libicui18n.so.56: cannot open shared object file: No such file or directory
pushd $DL_FOLDER/Qt_desktop/ >& /dev/null
  wget https://download.qt.io/online/qtsdkrepository/linux_x64/desktop/qt5_5150/qt.qt5.5150.gcc_64/5.15.0-0-202005140804icu-linux-Rhel7.2-x64.7z
  7z x 5.15.0-0-202005140804icu-linux-Rhel7.2-x64.7z
popd
