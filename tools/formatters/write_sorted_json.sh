#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
IFS=$'\n\t'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# shellcheck disable=SC1091
source "${DIR}/../ci/utils.bash" # for terminal colorization

echo "First argument to script is SRC file"
INPUT_FILE=$1
shift 1

echo "Next argument to script is DEST (output) file"
OUT_FILE=$1
shift 1

jq -S -f "${DIR}"/normalize.jq "$INPUT_FILE" > "$OUT_FILE"

THIS_FILENAME=$(basename "$0")
echo 'We assume this was run with '\''set -e'\'' (look at upper lines of this script).'
echo 'Assuming so, then getting here means:'
echo "${u_green}${THIS_FILENAME} '$INPUT_FILE' '$OUT_FILE' SUCCESS${u_resetcolor}"
