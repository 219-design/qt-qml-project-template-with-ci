#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${THISDIR}/rootdirhelper.bash"

DL_FOLDER_ANDROID=$DL_FOLDER/android_kits

mkdir -p $DL_FOLDER_ANDROID

QTMIRROR='http://ftp.fau.de/qtproject'

pip3 install --upgrade pip
pip3 install setuptools
pip3 install -r ${THISDIR}/for_pip/requirements.txt # install aqtinstall

if [ -d $DL_FOLDER/Qt_desktop/6.5.3/android_armv7/bin ]; then
    echo "no need to download qt6 android"
else

  python3 -m aqt install-qt --base "${QTMIRROR}" --outputdir $DL_FOLDER/Qt_desktop linux android 6.5.3 android_armv7 --autodesktop --modules \
     qtconnectivity \
     qtimageformats \
     qt5compat

  python3 -m aqt install-qt --base "${QTMIRROR}" --outputdir $DL_FOLDER/Qt_desktop linux android 6.5.3 android_arm64_v8a --autodesktop --modules \
     qtconnectivity \
     qtimageformats \
     qt5compat

  python3 -m aqt install-qt --base "${QTMIRROR}" --outputdir $DL_FOLDER/Qt_desktop linux android 6.5.3 android_x86 --autodesktop --modules \
     qtconnectivity \
     qtimageformats \
     qt5compat

  python3 -m aqt install-qt --base "${QTMIRROR}" --outputdir $DL_FOLDER/Qt_desktop linux android 6.5.3 android_x86_64 --autodesktop --modules \
     qtconnectivity \
     qtimageformats \
     qt5compat

fi

if [ -f $DL_FOLDER_ANDROID/commandlinetools-linux-6200805_latest.zip ]; then
  echo "no need to download android commandlinetools"
else
  $CUR_GUICODE_ROOT/tools/ci/install_android_kits.sh
fi
