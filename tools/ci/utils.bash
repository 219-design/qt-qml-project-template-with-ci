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
