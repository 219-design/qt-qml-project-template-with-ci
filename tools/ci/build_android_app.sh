#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

CUR_GIT_ROOT=$(git rev-parse --show-toplevel)

cd $CUR_GIT_ROOT

tools/ci/version.sh

source path_to_android_qmake.bash

mkdir -p build/for_android
cd build/for_android
# When you need release: CONFIG+=release
qmake CONFIG+=force_debug_info ../../ # debug info (symbols) are orthogonal to optimizations

make
make install INSTALL_ROOT=$CUR_GIT_ROOT/build/for_android/src/app/android-build

pushd $CUR_GIT_ROOT/build/for_android/src/app/ >& /dev/null
    make apk
popd >& /dev/null
