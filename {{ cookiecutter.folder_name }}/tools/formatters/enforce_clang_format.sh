#!/bin/bash

#
# Copyright (c) 2020, 219 Design, LLC
# See LICENSE.txt
#
# https://www.219design.com
# Software | Electrical | Mechanical | Product Design
#

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
IFS=$'\n\t'

# you may need to:
# sudo apt install clang-format-6.0

echo "Reading first argument. Path to folder holding C sources."
FOLDER_UNDER_FORMAT_CONTROL=$1
shift 1

only_report=0
if [[ -n ${1-} ]]; # the presence of ANY second arg makes this 'C.I.' mode (no editing files)
then
    only_report=1
fi

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

GOLDEN_RESULT_FILE="clang-format-6.0_clean_output.txt"

check_clang_format() {
  if [ $only_report != 0 ]; then
      while read filenames; do
        for d in "$filenames"; do
          echo $d
          clang_result=$(clang-format-10 -style=file -output-replacements-xml "$d")
          diff  <(echo $clang_result) <(cat "${THISDIR}/${GOLDEN_RESULT_FILE}")
          diff_rslt=$?
          # per 'man diff': Exit status is 0 if inputs are the same
          # If someone disables 'set -e', then explicitly fail here regardless:
          if [ $diff_rslt != 0 ]; then echo early termination at $LINENO; return -1; fi
        done
      done

      return 0
  fi

  while read filenames; do
    for d in "$filenames"; do
      echo $d
      clang_result=$(clang-format-10 -style=file -i "$d")
    done
  done
}

CUR_GIT_ROOT=$(git rev-parse --show-toplevel)

if [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
  WINBASHPATH=$(cygpath -u $CUR_GIT_ROOT)
  export PATH="$WINBASHPATH/dl_third_party/win_bin/:$PATH"
  GOLDEN_RESULT_FILE="clang-format-6.0_clean_output.win.txt.disableattr"
fi

cd $FOLDER_UNDER_FORMAT_CONTROL
top_level_dirs=(*/)

for dir in "${top_level_dirs[@]}"; do
  if [ -f "${dir}/.git" ]; then
      echo "Refusing to clang-format ${dir} - it appears to be a submodule."
  elif [ -f "${dir}/.do_not_format" ]; then
      echo "Refusing to clang-format ${dir} - you marked it .do_not_format"
  else
    # the option '-style=file' is a clang-format 'hardcode' ('file' is not a
    # variable nor a filename); it should cause clang-format to use
    # '.clang-format' from our git root.
    find ${dir} \
         \( -name '*.c' \
         -o -name '*.cc' \
         -o -name '*.cpp' \
         -o -name '*.h' \
         -o -name '*.hh' \
         -o -name '*.hpp' \) \
         | check_clang_format
  fi
done

echo 'We assume this was run with '\''set -e'\'' (look at upper lines of this script).'
echo 'Assuming so, then getting here means:'
echo 'SUCCESS'
