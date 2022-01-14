#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

# When we end up here from the cookiecutterize job, we cannot rely on git
#CUR_GIT_ROOT=$(git rev-parse --show-toplevel)

sudo apt-get update
sudo apt-get --assume-yes install clang-format-10
