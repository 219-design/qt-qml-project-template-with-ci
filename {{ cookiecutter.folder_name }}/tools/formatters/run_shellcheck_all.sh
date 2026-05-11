#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
IFS=$'\n\t'

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck disable=SC1091 # rootdirhelper.bash was not specified as input
source "${THISDIR}/../ci/rootdirhelper.bash"
# shellcheck disable=SC1091 # utils.bash was not specified as input
source "${THISDIR}/../ci/utils.bash" # for terminal colorization

# Use this repository's copy of shellcheck installed with our get_shellcheck.sh
export PATH="$DL_FOLDER"/shellcheck-v0.11.0:"$PATH"

# putting some info into the CI log:
type shellcheck
which shellcheck
shellcheck --version


shellcheck_this() {
  SHELLCHECK_FORMAT=${SHELLCHECK_FORMAT:-gcc}
  shellcheck --format="$SHELLCHECK_FORMAT" "$@"
}

cd "$CUR_GUICODE_ROOT"


if [ -f "${THISDIR}/run_shellcheck.exclusions.txt" ]; then
  readarray -t the_exclusions < "${THISDIR}/run_shellcheck.exclusions.txt"
else
  the_exclusions=()
fi

readarray -d '' candidates < <(find . -name "*sh" \
        ! -path "*/\.git/*" \
        ! -path "*/build/*" \
        ! -path "*/cbuild/*" \
        ! -path "*/cbuild_*" \
        ! -path "*/dl_third_party/*" \
        ! -path "*/third_party/*" \
        -print0 )

echo "${#candidates[@]} First-party scripts identified for shellcheck \
(exclusions applied later):"
echo "${candidates[@]}"
printf '\n\n\n'

echo "${#the_exclusions[@]} Files excluded from shellcheck:"
echo "${the_exclusions[@]}"
printf '\n\n\n'


for i in "${candidates[@]}"
do
  # https://stackoverflow.com/a/34066473/10278 (find string in bash array)
  if echo "${the_exclusions[@]}" | grep -q -w "$i"; then
    echo "First-party file NOT getting shellchecked: $i"
  else
    echo "shellcheck to run on: $i"
    shellcheck_this "$i"
  fi

done

covered=$(( ${#candidates[@]} - ${#the_exclusions[@]}))

THIS_FILENAME=$(basename "$0")
echo 'We assume this was run with '\''set -e'\'' (look at upper lines of this script).'
echo 'Assuming so, then getting here means:'
# shellcheck disable=SC2154 # u_green and u_resetcolor come from utils.bash
echo "${u_green}${THIS_FILENAME} SUCCESS on $covered files (${#the_exclusions[@]} excluded) ${u_resetcolor}"
