#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${THISDIR}/rootdirhelper.bash"

DL_FOLDER=$CUR_GUICODE_ROOT/dl_third_party/android_kits

mkdir -p $DL_FOLDER


pushd $DL_FOLDER >& /dev/null
  wget https://dl.google.com/android/repository/commandlinetools-linux-6200805_latest.zip
  echo "$(cat commandlinetools-linux-6200805_latest.zip.sha256) commandlinetools-linux-6200805_latest.zip" | sha256sum --check

  unzip commandlinetools-linux-6200805_latest.zip

  # in general we still want pipefail, but 'yes'/pipefail is misbehaving specifically on the GitHub CI runner
  # (another reference on pipefail and SIGPIPE: http://www.pixelbeat.org/programming/sigpipe_handling.html)
  set +o pipefail
  yes | tools/bin/sdkmanager --sdk_root=$PWD "platforms;android-33" \
    || test $? -eq 141 # ignoring the pipefail caused by 'yes' https://stackoverflow.com/a/33026977/10278

  yes | tools/bin/sdkmanager --sdk_root=$PWD "build-tools;34.0.0" \
    || test $? -eq 141 # ignoring the pipefail caused by 'yes' https://stackoverflow.com/a/33026977/10278

  # Note: 25.1.8937393 is also known as Android NDK r25b.
  # Qt 6.5.3 requires r25b, per:
  #  https://wiki.qt.io/Qt_6.5_Tools_and_Versions#Software_configurations_for_Qt_6.5.3
  yes | tools/bin/sdkmanager --sdk_root=$PWD "ndk;25.1.8937393" \
    || test $? -eq 141 # ignoring the pipefail caused by 'yes' https://stackoverflow.com/a/33026977/10278

  # restore pipefail now that we are done with 'yes' (btw: yes is used to accept the license prompt)
  set -Eeuxo pipefail

popd >& /dev/null
