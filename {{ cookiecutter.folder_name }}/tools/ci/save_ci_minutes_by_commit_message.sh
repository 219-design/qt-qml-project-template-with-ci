#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/


if [[ -n ${GITHUB_ACTIONS-} ]]
# The '-' hyphens above test without angering the 'set -u' about unbound variables
then
  echo "Assuming Github C.I. environment."

  IFS=$'\n' read -r -d '' -a COMMIT_MSG_LINES < <( git log -1 $GITHUB_SHA && printf '\0' )

  # GITHUB ENVIRONMENT WILL CONTAIN 'RUNNER_OS' AUTOMATICALLY.
  # THESE ARE THE POSSIBILITIES WE CONSIDER:
  #   RUNNER_OS=macOS
  #   RUNNER_OS=Linux

  # COMMIT MESSAGE MUST CONTAIN, RESPECTIVELY:
  #   ci:macos
  #   ci:linux

  # To run both flavors of CI for a commit, add BOTH the above 'ci:__' lines.

  CUR_RUNNER_LOWERCASE=$(echo "$RUNNER_OS" | tr '[:upper:]' '[:lower:]')
  COMMIT_LABEL="ci:$CUR_RUNNER_LOWERCASE"
  echo "Must now find $COMMIT_LABEL in commit message, or CI will exit."

  for msg_line in "${COMMIT_MSG_LINES[@]}"; do

    if [[ $msg_line == *"$COMMIT_LABEL"* ]]; then
        echo "Found $COMMIT_LABEL"
        exit 0
    fi

  done

  # Did not find it, so stop the CI
  exit 33
fi
