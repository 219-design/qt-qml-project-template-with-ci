#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

# Try various ways to print OS version info.
# This lets us keep a record of this in our CI logs,
# in case the CI docker images change.
uname -a       || true
lsb_release -a || true
gcc --version  || true  # oddly, gcc often prints great OS information
cat /etc/issue || true

# What environment variables did the C.I. system set? Print them:
env

# This only comes into play for certain dconf-able(s) like tzdata
export DEBIAN_FRONTEND=noninteractive # in addition to --assume-yes

# bitbucket CANNOT tolerate sudo
WITHSUDO=""
if [[ -n ${GITHUB_ACTIONS-} ]];
then
   # github REQUIRES it
   WITHSUDO="sudo"

   # A workaround (for github action) from: https://github.com/Microsoft/azure-pipelines-image-generation/issues/672
   $WITHSUDO apt-get remove -y clang-6.0 libclang-common-6.0-dev libclang1-6.0 libllvm6.0
   $WITHSUDO apt-get autoremove
   # end workaround
fi

$WITHSUDO apt-get update
$WITHSUDO apt-get --assume-yes install \
  build-essential \
  clang-format-6.0 \
  git \
  libc-bin \
  libdbus-1-3 \
  libdouble-conversion1 \
  libfontconfig1 \
  libgl1-mesa-dev \
  libgl1-mesa-glx \
  libglib2.0-0 \
  libglu1-mesa-dev \
  libharfbuzz0b \
  libicu60 \
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
  xvfb
