#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

# When we end up here from the cookiecutterize job, we cannot rely on git
#CUR_GIT_ROOT=$(git rev-parse --show-toplevel)
## BEGIN: clang-format from LLVM
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
# Fingerprint: 6084 F3CF 814B 57C1 CF12 EFD5 15CF 4D18 AF4F 7421

echo '' | sudo tee -a /etc/apt/sources.list
echo 'deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-10 main' | sudo tee -a /etc/apt/sources.list
echo 'deb-src http://apt.llvm.org/bionic/ llvm-toolchain-bionic-10 main' | sudo tee -a /etc/apt/sources.list

sudo apt-get update
sudo apt-get --assume-yes install clang-format-10

## END: clang-format from LLVM
