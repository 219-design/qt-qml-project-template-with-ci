#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

CUR_GIT_ROOT=$(git rev-parse --show-toplevel)
cd $CUR_GIT_ROOT

echo "First argument to script is build output path"
MYAPP_MOBILE_OUTPUT_PATH=$1
shift 1

echo "Next argument to script is qmake CONFIG token"
MYAPP_MOBILE_CONFIG_TOKEN=$1
shift 1


tools/ci/version.sh

source path_to_android_qmake.bash

mkdir -p ${MYAPP_MOBILE_OUTPUT_PATH}/
cd ${MYAPP_MOBILE_OUTPUT_PATH}/
qmake ${MYAPP_MOBILE_CONFIG_TOKEN} ../../

make
make install INSTALL_ROOT=$CUR_GIT_ROOT/${MYAPP_MOBILE_OUTPUT_PATH}/src/app/android-build

pushd $CUR_GIT_ROOT/${MYAPP_MOBILE_OUTPUT_PATH}/src/app/ >& /dev/null
    make apk
popd >& /dev/null
