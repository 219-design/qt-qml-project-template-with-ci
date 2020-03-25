#!/bin/bash

# A cookiecutter project will not have submodules set up. This initializes a
# cookiecutter project, removing all assumptions of an existing git repo.

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

rm -r build_qt_binaries

ln -s src/libstyles/imports/libstyles/images src/lib/qml/images
ln -s .qmake.conf qmake.conf
ln -s .clang-format clang-format

git init
git add .
git submodule add https://github.com/219-design/build_qt_binaries.git
git submodule update --init --recursive
git commit -m "init"

./tools/formatters/enforce_clang_format.sh
