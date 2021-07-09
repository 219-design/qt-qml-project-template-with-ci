#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

CUR_GIT_ROOT=$(git rev-parse --show-toplevel)

DL_FOLDER=$CUR_GIT_ROOT/dl_third_party/android_kits

mkdir -p $DL_FOLDER


pushd $DL_FOLDER >& /dev/null
  wget https://dl.google.com/android/repository/commandlinetools-linux-6200805_latest.zip
  echo "$(cat commandlinetools-linux-6200805_latest.zip.sha256) commandlinetools-linux-6200805_latest.zip" | sha256sum --check

  unzip commandlinetools-linux-6200805_latest.zip

  # in general we still want pipefail, but 'yes'/pipefail is misbehaving specifically on the GitHub CI runner
  # (another reference on pipefail and SIGPIPE: http://www.pixelbeat.org/programming/sigpipe_handling.html)
  set +o pipefail
  yes | tools/bin/sdkmanager --sdk_root=$PWD "platforms;android-27" \
    || test $? -eq 141 # ignoring the pipefail caused by 'yes' https://stackoverflow.com/a/33026977/10278

  yes | tools/bin/sdkmanager --sdk_root=$PWD "ndk-bundle" \
    || test $? -eq 141 # ignoring the pipefail caused by 'yes' https://stackoverflow.com/a/33026977/10278

  # restore pipefail now that we are done with 'yes' (btw: yes is used to accept the license prompt)
  set -Eeuxo pipefail

popd >& /dev/null
