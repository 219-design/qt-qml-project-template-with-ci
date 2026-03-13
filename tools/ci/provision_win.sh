#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck disable=SC1091 # rootdirhelper.bash was not specified as input
source "${DIR}/rootdirhelper.bash"

DL_FOLDER=$CUR_GUICODE_ROOT/dl_third_party

pip3 install -r "${DIR}/for_pip/requirements.txt"  # https://github.com/miurahr/aqtinstall
python3 -m aqt version # print version in CI log

# NOTE: as of Nov 23, 2020, it is not clear whether 'win64_msvc2019_64' is the right ARCH
# argument to pass to aqtinstall. We may need to try other options:
#   win64_msvc2017_64, win64_msvc2019_winrt_x64 ?
# FURTHER: as of Feb 11, 2022, this is untested on windows after switching from install to install-qt
# Refer to: https://github.com/miurahr/aqtinstall#usage

# https://github.com/miurahr/aqtinstall/issues/126 "Installing smaller subset of the libraries"
python -m aqt install-qt --outputdir "$DL_FOLDER/Qt_desktop" windows desktop 5.15.0 win64_msvc2019_64 --archives \
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


git checkout "${DL_FOLDER}/Qt_desktop/5.15.0/msvc2019_64/mkspecs/qconfig.pri"
