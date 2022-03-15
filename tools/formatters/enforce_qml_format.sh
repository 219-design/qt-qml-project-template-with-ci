#!/bin/bash

#
# Copyright (c) 2020, 219 Design, LLC
# See LICENSE.txt
#
# https://www.219design.com
# Software | Electrical | Mechanical | Product Design
#

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

echo "Reading first argument. Path to folder holding C sources."
FOLDER_UNDER_FORMAT_CONTROL=$1
shift 1

only_report=0
if [[ -n ${1-} ]]; # the presence of ANY second arg makes this 'C.I.' mode (no editing files)
then
    only_report=1
fi

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CUR_GIT_ROOT=$(git rev-parse --show-toplevel)
DL_FOLDER=${CUR_GIT_ROOT}/dl_third_party
if [[ -n ${MYAPP_TEMPLATE_DL_FOLDER_OVERRIDE-} ]]; then
  DL_FOLDER=${MYAPP_TEMPLATE_DL_FOLDER_OVERRIDE}
fi

MY_QT_VERSION=6.2.2
MY_FMT_EXTRAARGS="-i 2" # newer qmlfmt supports indent spaces count

if [[ -n ${MYAPP_TEMPLATE_LEGACY_UBUNTU18-} ]]; then
  MY_QT_VERSION=5.15.0
  MY_FMT_EXTRAARGS=""
  cp "${THISDIR}/enforce_qml_format.exclusions.legacy_qmlfmt" "${THISDIR}/enforce_qml_format.exclusions"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  qml_formatter="${DL_FOLDER}/Qt_desktop/${MY_QT_VERSION}/macos/extrabin/qmlfmt"
else
  export LD_LIBRARY_PATH="${DL_FOLDER}/Qt_desktop/${MY_QT_VERSION}/gcc_64/lib"
  qml_formatter="${DL_FOLDER}/Qt_desktop/${MY_QT_VERSION}/gcc_64/extrabin/qmlfmt"
fi

check_format() {
  if [ $only_report != 0 ]; then
      while read filenames; do
        for fl in "$filenames"; do
          echo checking format of "$fl"
          result=$("$qml_formatter" -l "$fl" ${MY_FMT_EXTRAARGS})
          if [[ ! -z "$result" ]]; then
              # https://stackoverflow.com/a/34066473/10278 (find string in bash array)
              if echo ${the_exclusions[@]} | grep -q -w "$fl"; then
                echo "INTENTIONAL FORGIVENESS OF $fl"
              else
                # If someone disables 'set -e', then explicitly fail here regardless:
                echo "You need to qmlfmt this file:"
                echo "$fl"
                return -1
              fi
          fi
        done
      done

      return 0
  fi

  while read filenames; do
    for fl in "$filenames"; do
      echo $fl

      # https://stackoverflow.com/a/34066473/10278 (find string in bash array)
      if echo ${the_exclusions[@]} | grep -q -w "$fl"; then
        echo "INTENTIONAL EXLUSION OF $fl"
      else
        "$qml_formatter" -w "$fl" ${MY_FMT_EXTRAARGS}
      fi
    done
  done
}

if [ -f "${THISDIR}/enforce_qml_format.exclusions" ]; then
  the_exclusions=($(awk -F= '{print $0}' "${THISDIR}/enforce_qml_format.exclusions"))
else
  the_exclusions=()
fi

cd $FOLDER_UNDER_FORMAT_CONTROL
top_level_dirs=(*/)

for dir in "${top_level_dirs[@]}"; do
  if [ -f "${dir}/.git" ]; then
      echo "Refusing to format ${dir} - it appears to be a submodule."
  elif [ -f "${dir}/.do_not_format" ]; then
      echo "Refusing to format ${dir} - you marked it .do_not_format"
  else
    # leaving the '-o' construct for future expansion guidance:
    find ${dir%/} \
         \( -name '*.qml' \
         -o -name '*.qml' \) \
         | check_format
  fi
done

echo 'We assume this was run with '\''set -e'\'' (look at upper lines of this script).'
echo 'Assuming so, then getting here means:'
echo 'SUCCESS'
