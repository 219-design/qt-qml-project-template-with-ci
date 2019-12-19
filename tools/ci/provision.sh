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

apt-get update
apt-get --assume-yes install \
  build-essential \
  clang-format-6.0 \
  git \
  libc-bin \
  libdouble-conversion1 \
  libgl1-mesa-dev \
  libgl1-mesa-glx \
  libglib2.0-0 \
  libglu1-mesa-dev \
  libharfbuzz0b \
  libicu60 \
  mesa-common-dev
