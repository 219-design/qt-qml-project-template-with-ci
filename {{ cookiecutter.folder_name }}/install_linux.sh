#!/bin/bash

#
# Copyright (c) 2020, 219 Design, LLC
# See LICENSE.txt
#
# https://www.219design.com
# Software | Electrical | Mechanical | Product Design
#

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR  # enter this script's directory.

source $DIR/path_to_qmake.bash

mkdir -p AppImage_staging

cd AppImage_staging
mkdir -p usr/bin
mkdir -p usr/lib
mkdir -p usr/share/applications
mkdir -p usr/share/icons/hicolor/256x256/apps

cp "$DIR/tools/AppImage/logo256.png" usr/share/icons/hicolor/256x256/apps/app.png
cp "$DIR/tools/AppImage/app.desktop" usr/share/applications/
cp "$DIR/build/src/app/"* usr/bin/

# unless you run linuxdeployqt with '-bundle-non-qt-libs', the end user on
# target install machine will need to run provision.sh, too. So put it in the
# image:
cp "$DIR/tools/ci/provision.sh" usr/bin/

cd $DIR  # enter this script's directory.

if [ -f linuxdeployqt-6-x86_64.AppImage ]; then
  echo "Skipping linuxdeployqt download. Looks done already."
else
  wget https://github.com/probonopd/linuxdeployqt/releases/download/6/linuxdeployqt-6-x86_64.AppImage
  chmod 0755 linuxdeployqt-6-x86_64.AppImage
fi

# if we extract linuxdeployqt instead of "running the AppImage", it works on
# more machines (in particular it will work even on those Docker boxes where
# FUSE is disabled)
./linuxdeployqt-6-x86_64.AppImage --appimage-extract

# '-unsupported-allow-new-glibc' enables running this script on Ubuntu 18
# ^^ BE ADVISED ^^ The above means your image ONLY RUNS ON 18 AND UP.
squashfs-root/usr/bin/linuxdeployqt \
    AppImage_staging/usr/share/applications/app.desktop \
    -extra-plugins=imageformats,platformthemes/libqgtk3.so,platforms/libqxcb.so,xcbglintegrations/libqxcb-glx-integration.so,platforminputcontexts/libibusplatforminputcontextplugin.so \
    -qmldir=src/ \
    -no-strip \
    -no-copy-copyright-files \
    -unsupported-allow-new-glibc \
    -verbose=2
