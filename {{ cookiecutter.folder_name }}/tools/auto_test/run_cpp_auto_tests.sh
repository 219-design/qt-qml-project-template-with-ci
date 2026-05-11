#!/bin/bash

#
# Copyright (c) 2020, 219 Design, LLC
# See LICENSE.txt
#
# https://www.219design.com
# Software | Electrical | Mechanical | Product Design
#

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck disable=SC1091 # rootdirhelper.bash was not specified as input
source "${THISDIR}/../ci/rootdirhelper.bash"
# shellcheck disable=SC1091 # utils.bash was not specified as input
source "${CUR_GUICODE_ROOT}/tools/ci/utils.bash" # for terminal colorization

# See docs on LLVM_PROFILE_FILE at: https://clang.llvm.org/docs/SourceBasedCodeCoverage.html
export LLVM_PROFILE_FILE="${CLANG_COVERAGE_DATA_DIR}/%p.profraw"

# Clear any existing gcov data so it does not contribute to this run's coverage results.
find "${BUILDOUT_DBG}" -name "*.gcda" -o -name "*.gcov" -delete
# Clear any existing llvm-cov data so it does not contribute to this run's coverage results.
rm -rf "${CLANG_COVERAGE_DATA_DIR}/coverage_data/"

# Note that we also "bake in" some sanitization options at compile-time
# through the use of our file: debug_sanitizer_config.cc
#   ... feel free to mix and match based on per-project needs.
export ASAN_OPTIONS="check_initialization_order=true:strict_init_order=true"
export ASAN_OPTIONS="${ASAN_OPTIONS}:detect_stack_use_after_return=1"

export UBSAN_OPTIONS="print_stacktrace=1"

# On a ROS2 project, you will likely need:
#  export ASAN_OPTIONS="${ASAN_OPTIONS}:new_delete_type_mismatch=0"
#  ^^ Until this is fixed: https://github.com/ros2/rclcpp/issues/2220

run_a_test() {
  while read filenames; do
    for fl in "$filenames"; do
      $fl
    done
  done
}

cd "$CUR_GUICODE_ROOT"

if [[ -n ${MYAPP_TEMPLATE_PREFER_QMAKE-} ]]; then
  OUR_TEST_BINARIES_DIR="${BUILDOUT_DBG}"/src/app
  if [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
    OUR_TEST_BINARIES_DIR="${BUILDOUT_DBG}"/windeployfolder
  fi
else
  OUR_TEST_BINARIES_DIR="${BUILDOUT_DBG}"/stage
  if [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
    OUR_TEST_BINARIES_DIR="${BUILDOUT_DBG}"/windeployfolder_debug
  fi
fi

# run all test binaries that got built in the expected dir:
find "${OUR_TEST_BINARIES_DIR}" -type f \( -name '*test' -o -name '*tests' -o -name '*test.exe' -o -name '*tests.exe' \) | run_a_test

echo 'We assume this was run with '\''set -e'\'' (look at upper lines of this script).'
echo 'Assuming so, then getting here means:'
# shellcheck disable=SC2154 # u_green and u_resetcolor come from utils.bash
echo "${u_green}run_cpp_auto_tests SUCCESS${u_resetcolor}"
