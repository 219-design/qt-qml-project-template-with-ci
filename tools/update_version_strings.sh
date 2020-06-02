#!/bin/bash
set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

echo 'reading two arguments ($1 is input file and $2 is output file)'
STRINGSFILE=$1
GENFILE=$2

F_EXT="${STRINGSFILE##*.}"

if [[ "$F_EXT" != "h" ]]; then
    echo "This script is designed to operate on a C++ header file"
    exit 1
fi

mkdir -p $(dirname "${GENFILE}")

BUILD_DATE=`date '+%Y-%m-%d'`

LAST_KNOWN_HASH=`git rev-parse --verify --short=10 HEAD`

NEW_DATELINE="constexpr char BUILD_ON_DATE[] = \"${BUILD_DATE}\";"
NEW_HASHLINE="constexpr char GIT_HASH_WHEN_BUILT[] = \"${LAST_KNOWN_HASH}\";"

if [[ "$OSTYPE" == "darwin"* ]]; then
  # find matching lines and replace WHOLE line with new strings
  gsed "/BUILD_ON_DATE/c ${NEW_DATELINE}" "$STRINGSFILE" > "$GENFILE" # 1. create genfile
  gsed -i "/GIT_HASH_WHEN_BUILT/c ${NEW_HASHLINE}" "$GENFILE"         # 2. then operate in-place on genfile
else
  # find matching lines and replace WHOLE line with new strings
  sed "/BUILD_ON_DATE/c ${NEW_DATELINE}" "$STRINGSFILE" > "$GENFILE" # 1. create genfile
  sed -i "/GIT_HASH_WHEN_BUILT/c ${NEW_HASHLINE}" "$GENFILE"         # 2. then operate in-place on genfile
fi
