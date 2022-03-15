#!/bin/bash

# A cookiecutter project will not have submodules set up. This initializes a
# cookiecutter project, removing all assumptions of an existing git repo.

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

ln -sf src/libstyles/imports/libstyles/images src/lib_app/qml/images
ln -sf .qmake.conf qmake.conf
ln -sf .clang-format clang-format

# the new repo is NOT a template. the new repo need not have a cookiecutter job:
rm -f .github/workflows/cookiecutter.yml

git init
git add .

git add -f AppImage_staging/.do_not_format
git add -f dl_third_party/.do_not_format
git add -f dl_third_party/Qt_desktop/5.15.0/clang_64/extrabin/macos/qmlfmt
git add -f dl_third_party/Qt_desktop/5.15.0/gcc_64/extrabin/qmlfmt
git add -f dl_third_party/Qt_desktop/6.2.2/macos/extrabin/qmlfmt
git add -f dl_third_party/Qt_desktop/6.2.2/gcc_64/extrabin/qmlfmt
git add -f dl_third_party/Qt_desktop/5.15.0/ios/mkspecs/qconfig.pri
git add -f dl_third_party/Qt_desktop/5.15.0/msvc2019_64/mkspecs/qconfig.pri
git add -f dl_third_party/android_kits/commandlinetools-linux-6200805_latest.zip.sha256

git commit -m "init"

./tools/formatters/enforce_clang_format.sh ${THISDIR}/src
echo "Examine git status to see if clang-format made changes. Refer to README.md for build instructions."
