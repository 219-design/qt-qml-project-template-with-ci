#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "${DIR}/rootdirhelper.bash"
source "${DIR}/utils.bash" # for terminal colorization

echo "First argument to script is build output path"
MYAPP_MOBILE_OUTPUT_PATH=$1
shift 1

echo "Next argument to script is qmake CONFIG token"
MYAPP_MOBILE_CONFIG_TOKEN=$1
shift 1

cmake --version # print version to CI logs.

file /usr/bin/c++ || true # cmake seems to choose `c++`, so print what it's linked to.
file /etc/alternatives/c++ || true
c++ --version || true

MYAPP_JOBS="-j$(nproc)"

if [[ -n ${UTILS_WE_ARE_RUNNING_IN_CI-} ]];
# The '-' hyphen above tests without angering the 'set -u' about unbound variables
then
  # Some projects will want to change this to speed up CI.
  # The rationale for -j1 in CI in our case is so that CI logs are more deterministic,
  # more human-readable (less interleaving of compiler invocations), and more diffable.
  MYAPP_JOBS="-j1"
fi

# Strip out usage of QML 'import QtGraphicalEffects' on Qt 6.
# Effects have moved to 'import QtQuick3D.Effects' and we have not
# yet made that available in our CI job.
git apply $CUR_GIT_ROOT/tools/ci/strip_effects_for_sake_of_qt6.patch || true


tools/ci/version.sh

source ${CUR_GUICODE_ROOT}/path_to_qmake.bash
source path_to_android_qmake.bash

mkdir -p ${MYAPP_MOBILE_OUTPUT_PATH}/
cd ${MYAPP_MOBILE_OUTPUT_PATH}/

export QT_HOST_PATH=$DL_FOLDER/Qt_desktop/6.5.3/gcc_64

# Note: 25.1.8937393 is also known as Android NDK r25b.
# Qt 6.5.3 requires r25b, per:
#  https://wiki.qt.io/Qt_6.5_Tools_and_Versions#Software_configurations_for_Qt_6.5.3
cmake -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
  -DANDROID_ABI="arm64-v8a" \
  -DANDROID_NDK_ROOT=$DL_FOLDER/android_kits/ndk/25.1.8937393/ \
  -DANDROID_SDK_ROOT=$DL_FOLDER/android_kits/ \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_FIND_ROOT_PATH:PATH=$DL_FOLDER/Qt_desktop/6.5.3/android_arm64_v8a \
  -DCMAKE_PREFIX_PATH:PATH=$DL_FOLDER/Qt_desktop/6.5.3/android_arm64_v8a \
  -DCMAKE_SYSTEM_NAME=Android \
  -DCMAKE_TOOLCHAIN_FILE=$DL_FOLDER/android_kits/ndk/25.1.8937393/build/cmake/android.toolchain.cmake \
  -DQT_ANDROID_ABIS="armeabi-v7a;arm64-v8a;x86;x86_64" \
  -DQT_ANDROID_BUILD_ALL_ABIS=ON \
  -S $CUR_GUICODE_ROOT

make ${MYAPP_JOBS}

THIS_FILENAME=$(basename "$0")

echo 'We assume this was run with '\''set -e'\'' (look at upper lines of this script).'
echo 'Assuming so, then getting here means:'
echo "${u_green}${THIS_FILENAME} SUCCESS${u_resetcolor}"
