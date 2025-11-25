#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

sudo xcode-select -s "/Applications/Xcode_15.1.0.app"

CUR_GIT_ROOT=$(git rev-parse --show-toplevel)

export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1
# Note: perhaps use HOMEBREW_NO_INSTALL_UPGRADE? https://docs.brew.sh/Manpage#environment

# TODO: remove '--overwrite python@3.12' when possible.
#   '--overwrite python@3.12' suddenly became necessary on newer github Mac runner images.
#   This is a github CI homebrew issue, March 2024.
#   https://github.com/actions/runner-images/issues/6817
brew \
  install \
  --overwrite python@3.12 \
     clang-format@21 \
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

${CUR_GIT_ROOT}/tools/ci/get_qt_libs_aqt_mac.sh
