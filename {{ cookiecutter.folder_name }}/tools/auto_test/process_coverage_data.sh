#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${THISDIR}/../ci/rootdirhelper.bash"
source "${CUR_GUICODE_ROOT}/tools/ci/utils.bash" # for terminal colorization

# Note coverage-related operations are structured to be no-ops unless the corresponding
# instrumentation is present.
COVERAGE_RUN_TIMESTAMP="$(date +%Y-%m-%d_%H%M%S_%N)"


process_coverage_data() {
    if [[ -d "${CLANG_COVERAGE_DATA_DIR}" ]]; then
        llvm-cov -version # print tool version info in CI log
        llvm-profdata -version # print tool version info in CI log

        llvm-profdata merge $(find ${CLANG_COVERAGE_DATA_DIR} -name "*.profraw") \
            -o ${CLANG_COVERAGE_DATA_DIR}/coverage.profdata
        CLANG_COVERAGE_REPORTS_DIR="${CUR_GIT_ROOT}/coverage_reports/clang-llvm/${COVERAGE_RUN_TIMESTAMP}"
        mkdir -p ${CLANG_COVERAGE_REPORTS_DIR}

        # Individually prefacing each relevant binary file with "-object" is seemingly
        # unavoidable for llvm-cov. In spite of the fact it's willing to treat a single
        # non-option argument as a binary file, it's not willing to do that for files
        # after the first, nor is it willing to accept a directory.
        LLVM_COV_BINARY_FILE_ARGS=""
        for BINARY_FILE in $(find -L ${BUILDOUT_DBG}/stage -type f); do
            LLVM_COV_BINARY_FILE_ARGS+=" -object ${BINARY_FILE}"
        done

        llvm-cov show \
            -instr-profile ${CLANG_COVERAGE_DATA_DIR}/coverage.profdata \
            ${LLVM_COV_BINARY_FILE_ARGS} \
            -sources ${CUR_GUICODE_ROOT}/src \
            -output-dir=${CLANG_COVERAGE_REPORTS_DIR} \
            -format=html \
            -show-branches=count \
            -show-line-counts-or-regions \
            -show-directory-coverage
    fi
    if [[ -n $(find ${BUILDOUT_DBG} -name "*.gcda") ]]; then
        gcovr --version # print tool version info in CI log

        GCC_COVERAGE_REPORTS_DIR="${CUR_GIT_ROOT}/coverage_reports/gcc-gcov/${COVERAGE_RUN_TIMESTAMP}"
        mkdir -p ${GCC_COVERAGE_REPORTS_DIR}
        pushd "${BUILDOUT_DBG}"
            # All this use of `realpath` is a workaround for: gcovr really does not like
            #   extra slashes in a path
            gcovr \
                --root $(realpath -sm ${CUR_GUICODE_ROOT}) \
                --filter $(realpath -sm ${CUR_GUICODE_ROOT}/src) \
                --html-nested $(realpath -sm ${GCC_COVERAGE_REPORTS_DIR}/index.html) \
                --decisions
        popd # ${BUILDOUT_DBG}
    fi
}

process_coverage_data

echo 'We assume this was run with '\''set -e'\'' (look at upper lines of this script).'
echo 'Assuming so, then getting here means:'
echo "${u_green}process_coverage_data SUCCESS${u_resetcolor}"
