#!/bin/bash

#
# Copyright (c) 2020, 219 Design, LLC
# See LICENSE.txt
#
# https://www.219design.com
# Software | Electrical | Mechanical | Product Design
#

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

# https://web.archive.org/web/20191121235402/https://confluence.atlassian.com/bitbucket/variables-in-pipelines-794502608.html
if [[ -n ${GITHUB_ACTIONS-} || -n ${BITBUCKET_REPO_OWNER-} || -n ${BITBUCKET_REPO_FULL_NAME-} ]];
# The '-' hyphens above test without angering the 'set -u' about unbound variables
then
  echo "Assuming C.I. environment."
  echo "Found at least one of GITHUB_ACTIONS, BITBUCKET_REPO_OWNER, BITBUCKET_REPO_FULL_NAME in env."

  ./tools/ci/provision.sh
  git submodule update --init # avoid '--recursive' (as long as we can) due to inner qmlfmt deps

  # kind of hacky to have this PATH bit as bitbucket-only.
  # once all developers are on 18.04 we can do this elsewhere
  PATH="$PWD/build_qt_binaries/qt5_opt_install/bin:$PATH"
else
  echo "Assuming we are NOT on bitbucket. Did not find BITBUCKET_REPO_OWNER nor BITBUCKET_REPO_FULL_NAME in env."
fi

tools/formatters/enforce_clang_format.sh check_only
tools/formatters/enforce_qml_format.sh check_only

./build_app.sh

# run all test binaries that got built in the expected dir:
tools/auto_test/run_cpp_auto_tests.sh
