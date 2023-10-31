#!/bin/bash

if [ "${BASH_SOURCE[0]}" -ef "$0" ]
then
    echo "Hey, you should source this script, not execute it!"
    exit 1
fi

if [[ -n ${TERM-} && ${TERM-} != "dumb" && ${TERM-} != "emacs" ]]; then
  # https://stackoverflow.com/a/20983251/10278
  u_red=`tput setaf 1`
  u_green=`tput setaf 2`
  u_resetcolor=`tput sgr0` # keep reset LAST. The above do change the output.
else
  u_red=''
  u_green=''
  u_resetcolor=''
fi

# https://web.archive.org/web/20191121235402/https://confluence.atlassian.com/bitbucket/variables-in-pipelines-794502608.html
if [[ -n ${GITHUB_ACTIONS-} || -n ${BITBUCKET_REPO_OWNER-} || -n ${BITBUCKET_REPO_FULL_NAME-} ]];
# The '-' hyphens above test without angering the 'set -u' about unbound variables
then
  export UTILS_WE_ARE_RUNNING_IN_CI=1
  echo "Assuming C.I. environment."
  echo "Found at least one of GITHUB_ACTIONS, BITBUCKET_REPO_OWNER, BITBUCKET_REPO_FULL_NAME in env."
fi

windows_deploy () {
  FLAVOR="$1"
  EXEDIR="$2"
  PDIR="$3"
  SHIPDIR="$4"
  mkdir -p ${SHIPDIR}
  cp ${EXEDIR}/*.exe ${SHIPDIR}  # copy main and tests. tests must be side-by-side with Qt DLL(s), too.
  cp ${PDIR}/libstylesplugin.dll ${SHIPDIR}

  pushd ${SHIPDIR}
    # Technically, we should set qmldir to our own 'src' dir, to allow
    # windeployqt to deploy the MINIMUM necessary QML support files. However,
    # this is a popular workaround for various bugs and annoyances -- by
    # pointing qmldir to the Qt framework install dir itself, we just deploy ALL
    # qml-related support files that Qt offers.
    windeployqt "${FLAVOR}" --qmldir "${WINALLQML}"  app.exe
  popd
}
