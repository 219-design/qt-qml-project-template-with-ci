#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Whoops! There is a SEPARATE script for Mac OSX. This one is linux-specific."
  exit -1
fi

CUR_GIT_ROOT=$(git rev-parse --show-toplevel)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

DL_FOLDER=$CUR_GIT_ROOT/dl_third_party
if [[ -n ${MYAPP_TEMPLATE_DL_FOLDER_OVERRIDE-} ]]; then
  DL_FOLDER=${MYAPP_TEMPLATE_DL_FOLDER_OVERRIDE}
fi

# --- Other mirrors (for times of trouble) -------
# http://qt-mirror.dannhauer.de/
# http://mirrors.ukfast.co.uk/sites/qt.io
# http://mirror.csclub.uwaterloo.ca/qtproject/

#QTMIRROR='http://mirrors.ocf.berkeley.edu/qt/' # was being slow, 2021-Mar-24
QTMIRROR='http://ftp.fau.de/qtproject'
QTSIXMIRROR='http://ftp.fau.de/qtproject'

sudo pip3 uninstall -y importlib_metadata || true # to prevent https://github.com/miurahr/aqtinstall/issues/221
sudo pip3 install -r ${DIR}/for_pip/requirements.txt # install aqtinstall

if [ -d $DL_FOLDER/Qt_desktop/5.15.0/gcc_64/bin ]; then
    echo "no need to download qt5 for desktop"
else

  if [[ -n ${MYAPP_TEMPLATE_QT6-} ]]; then
    # https://github.com/miurahr/aqtinstall/issues/126 "Installing smaller subset of the libraries"
    python3 -m aqt install --base "${QTSIXMIRROR}" --outputdir $DL_FOLDER/Qt_desktop 6.0.0 linux desktop --archives \
     icu \
     qtbase \
     qtconnectivity \
     qtdeclarative \
     qtgraphicaleffects \
     qtimageformats \
     qtquickcontrols \
     qtquickcontrols2 \
     qtsvg \
     qttools

    # we still need qt5 in order to execute qmlfmt. (until we can recompile qmlfmt with qt6)
    # https://github.com/miurahr/aqtinstall/issues/126 "Installing smaller subset of the libraries"
    python3 -m aqt install --base "${QTMIRROR}" --outputdir $DL_FOLDER/Qt_desktop 5.15.0 linux desktop --archives \
     icu \
     qtbase
  else
    # https://github.com/miurahr/aqtinstall/issues/126 "Installing smaller subset of the libraries"
    python3 -m aqt install --base "${QTMIRROR}" --outputdir $DL_FOLDER/Qt_desktop 5.15.0 linux desktop --archives \
     icu \
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

fi
