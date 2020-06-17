#!/bin/bash

#
# Copyright (c) 2020, 219 Design, LLC
# See LICENSE.txt
#
# https://www.219design.com
# Software | Electrical | Mechanical | Product Design
#

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

git config --global user.name "Workflow Worker"
git config --global user.email "nobody@219design.com"

# Cookiecutterize the project and stage the repo for push to branch
cd $GITHUB_WORKSPACE
git checkout -b qt_cookiecutter
./cookiecutter/cookiecutterize.sh
git commit -am "cookiecutterized invocation($INVOCATION_ID)"

# Exercise cookiecutter and associated tests
cd $HOME
pip3 install -U pip setuptools
pip3 install cookiecutter
pip3 show cookiecutter
sudo apt install tree
$HOME/.local/bin/cookiecutter --no-input --verbose $GITHUB_WORKSPACE/
cd $HOME/qt_qml_project_template_with_ci

if [[ -n ${GITHUB_ACTIONS-} || -n ${BITBUCKET_REPO_OWNER-} || -n ${BITBUCKET_REPO_FULL_NAME-} ]];
# The '-' hyphens above test without angering the 'set -u' about unbound variables
then
  echo "Assuming C.I. environment."
  echo "Found at least one of GITHUB_ACTIONS, BITBUCKET_REPO_OWNER, BITBUCKET_REPO_FULL_NAME in env."
  ./tools/ci/get_llvm_clang-format.sh # we need to install clang-format for init_repo.sh
fi

./init_repo.sh
git clean -dxf # after init_repo, this proves that everything REQUIRED is in git

./run_all_tests.sh || exit 1

if [ "$GITHUB_REF" != "refs/heads/master" ]; then
    echo "NOT BUILT ON MASTER. Not pushing cookiecutter branch."
    echo "SUCCESS"
    exit 0
fi

# Tests were successful, continue pushing the cutterized branch upstream
remote_repo="https://${COOKIECUTTER_PUSH_USER}:${COOKIECUTTER_PUSH_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
cd $GITHUB_WORKSPACE
git push "${remote_repo}" HEAD:cookiecutter --force
