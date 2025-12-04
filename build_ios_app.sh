#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

pushd .
trap "popd" EXIT HUP INT QUIT TERM

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR  # enter this script's directory. (in case called from root of repository)
source "${DIR}/tools/ci/rootdirhelper.bash"

$DIR/tools/ci/version.sh

source $DIR/path_to_ios_qmake.bash

mkdir -p "${BUILDOUT_DBG}"/for_ios

pushd "${BUILDOUT_DBG}"/for_ios

  # When you need release: CONFIG+=release
  qmake CONFIG+=force_debug_info "$DIR" # debug info (symbols) are orthogonal to optimizations

  make

popd
