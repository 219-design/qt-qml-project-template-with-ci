#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${DIR}/rootdirhelper.bash"

DL_FOLDER=$CUR_GUICODE_ROOT/dl_third_party
if [[ -n ${MYAPP_TEMPLATE_DL_FOLDER_OVERRIDE-} ]]; then
  DL_FOLDER=${MYAPP_TEMPLATE_DL_FOLDER_OVERRIDE}
fi

pip3 install -r ${DIR}/requirements.txt  # https://github.com/miurahr/aqtinstall

python3 -m aqt install-qt --outputdir $DL_FOLDER/Qt_desktop \
  windows desktop 6.5.3 win64_msvc2019_64 \
  --modules \
  qtconnectivity \
  qtimageformats \
  qt5compat
