#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

CUR_GIT_ROOT=$(git rev-parse --show-toplevel)

DL_FOLDER=$CUR_GIT_ROOT/dl_third_party

pip3 install aqtinstall  # https://github.com/miurahr/aqtinstall
#
# NOTE: as of Nov 23, 2020, it is not clear whether 'win64_msvc2019_64' is the right ARCH
# argument to pass to aqtinstall. We may need to try other options:
#   win64_msvc2017_64, win64_msvc2019_winrt_x64 ?
# Refer to: https://github.com/miurahr/aqtinstall#usage

# https://github.com/miurahr/aqtinstall/issues/126 "Installing smaller subset of the libraries"
python -m aqt install --outputdir $DL_FOLDER/Qt_desktop 5.15.0 windows desktop win64_msvc2019_64 --archives \
        icu \
        qtbase \
        qtconnectivity \
        qtdeclarative \
        qtgraphicaleffects \
        qtimageformats \
        qtquickcontrols \
        qtquickcontrols2 \
        qtsvg \
        qttools

mkdir -p $DL_FOLDER/win_bin/

pushd $DL_FOLDER/win_bin/ >& /dev/null
  curl -o clang-format-r375090.exe https://prereleases.llvm.org/win-snapshots/clang-format-r375090.exe
  curl -o clang-format-r375090.exe.sig https://prereleases.llvm.org/win-snapshots/clang-format-r375090.exe.sig
  gpg --keyserver pgp.key-server.io --recv-key 345AD05D
  gpg --verify clang-format-r375090.exe.sig clang-format-r375090.exe
  mv clang-format-r375090.exe clang-format-10
popd >& /dev/null
