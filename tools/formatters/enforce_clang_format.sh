#!/bin/bash

#
# Copyright (c) 2020, 219 Design, LLC
# See LICENSE.txt
#
# https://www.219design.com
# Software | Electrical | Mechanical | Product Design
#

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

# you may need to:
# sudo apt install clang-format-6.0

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

only_report=0
if [[ -n ${1-} ]]; # the presence of ANY arg makes this 'C.I.' mode (no editing files)
then
    only_report=1
fi

check_clang_format() {
  if [ $only_report != 0 ]; then
      while read filenames; do
        for d in "$filenames"; do
          echo $d
          clang_result=$(clang-format-6.0 -style=file -output-replacements-xml "$d")
          diff  <(echo $clang_result) <(cat "${THISDIR}/clang-format-6.0_clean_output.txt")
          diff_rslt=$?
          # per 'man diff': Exit status is 0 if inputs are the same
          # If someone disables 'set -x', then explicitly fail here regardless:
          if [ $diff_rslt != 0 ]; then echo early termination at $LINENO; return -1; fi
        done
      done

      return 0
  fi

  while read filenames; do
    for d in "$filenames"; do
      echo $d
      clang_result=$(clang-format-6.0 -style=file -i "$d")
    done
  done
}

CUR_GIT_ROOT=$(git rev-parse --show-toplevel)

cd $CUR_GIT_ROOT
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

echo 'We assume this was run with '\''set -x'\'' (look at upper lines of this script).'
echo 'Assuming so, then getting here means:'
echo 'SUCCESS'
