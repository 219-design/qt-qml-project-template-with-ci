#!/bin/bash

if [ "${BASH_SOURCE[0]}" -ef "$0" ]
then
    echo "Hey, you should source this script, not execute it!"
    exit 1
fi

CUR_GIT_ROOT=$(git rev-parse --show-toplevel)

DL_FOLDER=$CUR_GIT_ROOT/dl_third_party
if [[ -n ${MYAPP_TEMPLATE_DL_FOLDER_OVERRIDE-} ]]; then
  DL_FOLDER=${MYAPP_TEMPLATE_DL_FOLDER_OVERRIDE}
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="$DL_FOLDER/Qt_desktop/5.15.0/clang_64/bin/:$PATH"
elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
  WINDLPATH=$(cygpath -u $DL_FOLDER)
  export PATH="${WINDLPATH}/Qt_desktop/5.15.0/msvc2019_64/bin:$PATH"
  export WINALLQML="${DL_FOLDER}/Qt_desktop/5.15.0/msvc2019_64/qml"
else
  if [[ -n ${MYAPP_TEMPLATE_QT6-} ]]; then
    export PATH="$DL_FOLDER/Qt_desktop/6.2.2/gcc_64/bin/:$PATH"
  else
    export PATH="$DL_FOLDER/Qt_desktop/5.15.0/gcc_64/bin/:$PATH"
  fi
fi
