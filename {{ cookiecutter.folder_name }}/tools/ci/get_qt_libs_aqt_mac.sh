#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

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

# TODO: remove --break-system-packages, likely by using a venv.
#  --break-system-packages works around a cascading consequence of:
#  https://github.com/actions/runner-images/issues/6817
pip3 install --upgrade pip --break-system-packages # related to homebrew issue, March 2024
pip3 install --break-system-packages setuptools
pip3 install --break-system-packages -r ${DIR}/for_pip/requirements.txt # install aqtinstall

if [ -d $DL_FOLDER/Qt_desktop/6.5.3/macos/bin ]; then
    echo "no need to download qt for desktop"
else

  # https://github.com/miurahr/aqtinstall/issues/126 "Installing smaller subset of the libraries"
  python3 -m aqt install-qt --base "${QTSIXMIRROR}" --outputdir $DL_FOLDER/Qt_desktop mac desktop 6.5.3 --modules \
   qtconnectivity \
   qtimageformats \
   qt5compat

  python3 -m aqt install-qt --base "${QTSIXMIRROR}" --outputdir $DL_FOLDER/Qt_desktop mac ios 6.5.3 --modules \
   qtconnectivity \
   qtimageformats \
   qt5compat

fi
