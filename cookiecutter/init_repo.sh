#!/bin/bash

# A cookiecutter project will not have submodules set up. This initializes a
# cookiecutter project, removing all assumptions of an existing git repo.

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

ln -sf src/libstyles/imports/libstyles/images src/lib/qml/images
ln -sf .qmake.conf qmake.conf
ln -sf .clang-format clang-format

# the new repo is NOT a template. the new repo need not have a cookiecutter job:
rm -f .github/workflows/cookiecutter.yml

git init
git add .
git commit -m "init"

./tools/formatters/enforce_clang_format.sh
echo "Examine git status to see if clang-format made changes. Refer to README.md for build instructions."
