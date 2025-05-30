#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ARCH_DOC_DIR=${THISDIR}/
INC_2_DOT=${ARCH_DOC_DIR}/print_graph_edges_from_pound_includes.py

wants_help=0
for i in ${@}; do
  if [ "-h" == "$i" ]; then
    wants_help=1
  elif [ "--help" == "$i" ]; then
    wants_help=1
  fi
done

if [ "$wants_help" == 1 ]; then
  set +x
  echo ""
  echo 'Note that `generate_graph.sh` forwards arguments and delegates most of the work to:'
  echo "  ./print_graph_edges_from_pound_includes.py"
  echo ""
  echo "Therefore, when diagnosing an issue, you may wish to directly invoke the py script."
  echo ""
  set -x
  ${INC_2_DOT} --help
  exit 0
fi

${INC_2_DOT} "$@"  > ${ARCH_DOC_DIR}/sorted_edges.tmp

# Re-compose a whole graphviz dot files, concatenating a header + edges + tail
cat \
  ${ARCH_DOC_DIR}/dot_head.part \
  ${ARCH_DOC_DIR}/sorted_edges.tmp \
  ${ARCH_DOC_DIR}/dot_tail.part \
  > ${ARCH_DOC_DIR}/all_src.dot

rm ${ARCH_DOC_DIR}/sorted_edges.tmp # remove our temp file

dot -Tsvg < ${ARCH_DOC_DIR}/all_src.dot > ${ARCH_DOC_DIR}/all_src.svg

echo 'We assume this was run with '\''set -e'\'' (look at upper lines of this script).'
echo 'Assuming so, then getting here means:'
echo "generate_graph.sh SUCCESS"
