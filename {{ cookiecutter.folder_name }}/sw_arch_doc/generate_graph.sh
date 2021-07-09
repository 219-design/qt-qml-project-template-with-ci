#!/bin/bash

# This script relies on the following for heavy lifting:
# https://www.flourish.org/cinclude2dot/cinclude2dot

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ARCH_DOC_DIR=${THISDIR}/
INC_2_DOT=${ARCH_DOC_DIR}/third_party/cinclude2dot

echo "Reading first argument. Path to folder holding C sources to be diagrammed."
SOURCES_DIR=$1
shift 1

echo "Reading second argument. Path that encloses all headers that you wish the script to find."
INCLUDES_DIR=$1
shift 1

pushd ${SOURCES_DIR} >& /dev/null
    ${INC_2_DOT} --quotetypes quote --merge module --include ${INCLUDES_DIR} > ${ARCH_DOC_DIR}/all_src.dot
popd >& /dev/null

THEGREP=grep
THESED=sed
if [[ "$OSTYPE" == "darwin"* ]]; then
  THEGREP=ggrep
  THESED=gsed
fi

# Grep (filter) only the edges lines and sort them (so we can have meaningful
# diffs over time):
cat ${ARCH_DOC_DIR}/all_src.dot | "${THEGREP}" -P '\t"' | sort > sorted_edges.tmp

# Re-compose a whole graphviz dot files, concatenating a header + edges + tail
cat \
  ${ARCH_DOC_DIR}/dot_head.part \
  sorted_edges.tmp \
  ${ARCH_DOC_DIR}/dot_tail.part \
  > ${ARCH_DOC_DIR}/all_src.dot

rm sorted_edges.tmp # remove our temp file

# Delete lines from the dot file that pertain to utility modules that "clog" the
# graph and do not add much insight to internal module relationships.
#
# The lines targeted for deletion look like:
#     "driver" -> "error"
#     "div" -> "stringclass"
"${THESED}" -i "/\"\bam_i_inside_debugger\b\"/d" ${ARCH_DOC_DIR}/all_src.dot
"${THESED}" -i "/\"\bcli_options\b\"/d" ${ARCH_DOC_DIR}/all_src.dot
"${THESED}" -i "/\"\blogging_tags\b\"/d" ${ARCH_DOC_DIR}/all_src.dot
"${THESED}" -i "/\"\bresource_helper\b\"/d" ${ARCH_DOC_DIR}/all_src.dot
"${THESED}" -i "/\"\bresources\b\"/d" ${ARCH_DOC_DIR}/all_src.dot
"${THESED}" -i "/\"\busage_log_t\b\"/d" ${ARCH_DOC_DIR}/all_src.dot

dot -Tsvg < ${ARCH_DOC_DIR}/all_src.dot > ${ARCH_DOC_DIR}/all_src.svg
