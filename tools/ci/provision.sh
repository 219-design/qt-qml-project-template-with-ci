#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

# This only comes into play for certain dconf-able(s) like tzdata
export DEBIAN_FRONTEND=noninteractive # in addition to --assume-yes

# Deal with environments (such as bitbucket CI) that lack sudo
if ! [ -x "$(command -v sudo)" ]; then
  apt-get update
  apt-get --assume-yes install sudo
fi

if [[ -n ${GITHUB_ACTIONS-} ]];
then
   # A workaround (for github action) from: https://github.com/Microsoft/azure-pipelines-image-generation/issues/672
   sudo apt-get remove -y clang-6.0 libclang-common-6.0-dev libclang1-6.0 libllvm6.0
   sudo apt-get autoremove
   # end workaround
fi

sudo apt-get update
sudo apt-get --assume-yes install \
  build-essential \
  clang-format-6.0 \
  git \
  libc-bin \
  libdbus-1-3 \
  libdouble-conversion1 \
  libfontconfig1 \
  libfuse2 \
  libgl1-mesa-dev \
  libgl1-mesa-glx \
  libglib2.0-0 \
  libglu1-mesa-dev \
  libgtk-3-0 \
  libharfbuzz0b \
  libicu60 \
  libjpeg8 \
  libtiff5 \
  libxcb-icccm4 \
  libxcb-image0 \
  libxcb-keysyms1 \
  libxcb-render-util0 \
  libxcb-render0 \
  libxcb-xinerama0 \
  libxcb-xkb1 \
  libxkbcommon-x11-0 \
  libxkbcommon0 \
  mesa-common-dev \
  psmisc \
  python3 \
  wget \
  xvfb
