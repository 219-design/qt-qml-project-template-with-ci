#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "${THISDIR}/rootdirhelper.bash"

if [[ "$OSTYPE" == "darwin"* ]]; then
  ${CUR_GUICODE_ROOT}/tools/ci/provision_mac.sh
  exit 0
fi

if [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
  ${CUR_GUICODE_ROOT}/tools/ci/provision_win.sh
  exit 0
fi

# This only comes into play for certain dconf-able(s) like tzdata
export DEBIAN_FRONTEND=noninteractive # in addition to --assume-yes

# Deal with environments (such as bitbucket CI) that lack sudo
if ! [ -x "$(command -v sudo)" ]; then
  apt-get update
  apt-get --assume-yes install sudo
fi

sudo dpkg --add-architecture i386

sudo apt-get update

# handling libc6:i386 all by itself, and right up front, seems to
# workaround some kind of recurring ubuntu apt issue. see:
# https://bugs.launchpad.net/ubuntu-cdimage/+bug/1871268
# https://github.com/openjdk/jdk/pull/2128/files
sudo apt-get --assume-yes install libc6:i386 libc6-dev:i386

# libstdc++-10-dev was added for the sake of clang. see: https://stackoverflow.com/q/26333823/10278
sudo apt-get --assume-yes install \
  build-essential \
  curl \
  graphviz \
  gdb \
  git \
  gnupg \
  g++-11 \
  libc-bin \
  libdbus-1-3 \
  libfontconfig1 \
  libfuse2 \
  libgcc1:i386 \
  libgl1-mesa-dev \
  libgl1-mesa-glx \
  libglib2.0-0 \
  libglu1-mesa-dev \
  libgtk-3-0 \
  libharfbuzz0b \
  libjpeg8 \
  libncurses5:i386 \
  libsdl1.2debian:i386 \
  libstdc++-10-dev \
  libstdc++6:i386 \
  libtiff5 \
  libxcb-cursor0 \
  libxcb-icccm4 \
  libxcb-image0 \
  libxcb-keysyms1 \
  libxcb-randr0 \
  libxcb-render-util0 \
  libxcb-render0 \
  libxcb-xinerama0 \
  libxcb-xkb1 \
  libxkbcommon-x11-0 \
  libxkbcommon0 \
  mesa-common-dev \
  openjdk-8-jdk \
  openjdk-8-jre \
  p7zip-full \
  psmisc \
  python3 \
  python3-pip \
  unzip \
  wget \
  xvfb \
  zlib1g:i386

## BEGIN: clang-format from LLVM
${CUR_GUICODE_ROOT}/tools/ci/get_llvm_clang-format.sh
## END: clang-format from LLVM


${CUR_GUICODE_ROOT}/tools/ci/get_qt_libs.sh
