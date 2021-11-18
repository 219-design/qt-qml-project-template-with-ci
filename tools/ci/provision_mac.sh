#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

# https://github.com/actions/virtual-environments/issues/777
sudo xcode-select -s "/Applications/Xcode_11.7.app"

CUR_GIT_ROOT=$(git rev-parse --show-toplevel)

brew install \
     clang-format@11 \
     fontconfig \
     gdbm \
     glib \
     gnu-sed \
     graphviz \
     grep \
     libtool \
     p7zip \
     pcre \
     pcre2 \
     readline \
     sqlite \
     tree \
     x265 \
     xz

pushd /usr/local/bin >& /dev/null
  sudo ln -sf clang-format clang-format-10
  sudo ln -sf clang-format-11 clang-format-10
popd >& /dev/null

${CUR_GIT_ROOT}/tools/ci/get_qt_libs_mac.sh
