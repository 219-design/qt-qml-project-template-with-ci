#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

sudo xcode-select -s "/Applications/Xcode_14.3.1.app"

CUR_GIT_ROOT=$(git rev-parse --show-toplevel)

export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1
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
  sudo ln -sf clang-format clang-format-12
  sudo ln -sf clang-format-11 clang-format-12
popd >& /dev/null

${CUR_GIT_ROOT}/tools/ci/get_qt_libs_aqt_mac.sh
