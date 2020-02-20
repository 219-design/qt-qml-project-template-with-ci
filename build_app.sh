#!/bin/bash

#
# Copyright (c) 2020, 219 Design, LLC
# See LICENSE.txt
#
# https://www.219design.com
# Software | Electrical | Mechanical | Product Design
#

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

pushd .
trap "popd" EXIT HUP INT QUIT TERM

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR  # enter this script's directory. (in case called from root of repository)


if [ -f build_qt_binaries/.git ]; then
  echo "Skipping any work in qt5 bin submodule. Looks done already."
else
  git submodule update --init --recursive
fi

source $DIR/path_to_qmake.bash

cd build
qmake "$DIR"

make

make install # puts necessary items side-by-side with app exe
