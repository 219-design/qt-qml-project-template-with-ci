#!/bin/bash
set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

echo "reading single argument (should be the path to the strings file to update)"
STRINGSFILE=$1

F_EXT="${STRINGSFILE##*.}"

if [[ "$F_EXT" != "h" ]]; then
    echo "This script is designed to operate on a C++ header file"
    exit 1
fi

BUILD_DATE=`date '+%Y-%m-%d'`

LAST_KNOWN_HASH=`git rev-parse --verify --short=10 HEAD`

NEW_DATELINE="constexpr char BUILD_ON_DATE[] = \"${BUILD_DATE}\";"
NEW_HASHLINE="constexpr char GIT_HASH_WHEN_BUILT[] = \"${LAST_KNOWN_HASH}\";"

# find matching lines and replace WHOLE line with new strings
sed -i "/BUILD_ON_DATE/c ${NEW_DATELINE}" "$STRINGSFILE"
sed -i "/GIT_HASH_WHEN_BUILT/c ${NEW_HASHLINE}" "$STRINGSFILE"
