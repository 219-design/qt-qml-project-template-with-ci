#!/bin/bash

if [ "${BASH_SOURCE[0]}" -ef "$0" ]
then
    echo "Hey, you should source this script, not execute it!"
    exit 1
fi

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${THISDIR}/tools/ci/rootdirhelper.bash"

DL_FOLDER=$CUR_GUICODE_ROOT/dl_third_party
if [[ -n ${MYAPP_TEMPLATE_DL_FOLDER_OVERRIDE-} ]]; then
  DL_FOLDER=${MYAPP_TEMPLATE_DL_FOLDER_OVERRIDE}
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="$DL_FOLDER/Qt_desktop/6.5.3/macos/bin/:$PATH"
elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
  WINDLPATH=$(cygpath -u $DL_FOLDER)
  export PATH="${WINDLPATH}/Qt_desktop/5.15.0/msvc2019_64/bin:$PATH"
  export WINALLQML="${DL_FOLDER}/Qt_desktop/5.15.0/msvc2019_64/qml"

  # Variables used by CMakeLists
  export Qt6_DIR="${WINDLPATH}/Qt_desktop/6.5.3/msvc2019_64/lib/cmake/Qt6/"
  export Qt5_DIR="${WINDLPATH}/Qt_desktop/5.15.0/msvc2019_64/lib/cmake/Qt5/"
else
  if [[ -n ${MYAPP_TEMPLATE_QT6-} ]]; then
    export PATH="$DL_FOLDER/Qt_desktop/6.5.3/gcc_64/bin/:$PATH"
  else
    export PATH="$DL_FOLDER/Qt_desktop/5.15.0/gcc_64/bin/:$PATH"
  fi

  # Variables used by CMakeLists
  export Qt6_DIR="${DL_FOLDER}/Qt_desktop/6.5.3/gcc_64/lib/cmake/Qt6/"
  export Qt5_DIR="${DL_FOLDER}/Qt_desktop/5.15.0/gcc_64/lib/cmake/Qt5/"
fi
