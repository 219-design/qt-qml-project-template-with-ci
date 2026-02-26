#!/bin/bash

#
# Copyright (c) 2023, 219 Design, LLC
# See LICENSE.txt
#
# https://www.219design.com
# Software | Electrical | Mechanical | Product Design
#

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
IFS=$'\n\t'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$DIR"  # enter this script's directory. (in case called from root of repository)
# shellcheck disable=SC1091 # rootdirhelper.bash was not specified as input
source "${DIR}/tools/ci/rootdirhelper.bash"
# shellcheck disable=SC1091 # utils.bash was not specified as input
source "${CUR_GUICODE_ROOT}/tools/ci/utils.bash" # for terminal colorization

chosen_buildtype="Debug"
chosen_folder="${BUILDOUT_DBG}"
if [[ -n ${1-} ]]; # the presence of ANY arg becomes our "RELEASE build type name"
then
    chosen_buildtype="${1}"
    chosen_folder="${BUILDOUT_OPT}"
fi

if [[ -n ${UTILS_WE_ARE_RUNNING_IN_CI-} ]]; then
  # Some workflows on github build multiple times with different flags.
  # Therefore, when under CI, we always build from zero. Remove any prior artifacts:
  rm -rf "${chosen_folder}"
fi

cmake --version # print version to CI logs.

file /usr/bin/c++ || true # cmake seems to choose `c++`, so print what it's linked to.
file /etc/alternatives/c++ || true
c++ --version || true

MYAPP_JOBS="-j$(nproc)"

if [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
  if [[ -z ${VCToolsInstallDir-} ]]; then
    echo "WHOOPS. vcvars64 (or vcvarsall) was not called yet."
    echo "You MUST start a VISUAL STUDIO command prompt. (Then start git-bash from within it.)"
    echo "Read the above and try again."
    exit 1
  fi

  makecmd=nmake
  MYAPP_JOBS=""
  MYAPP_EXTRA_CONF=( "-G" "NMake Makefiles" )

  MSVCPATHFORBUILDING=$(cygpath -u "${VCToolsInstallDir}/bin/HOSTx64/x64")
  export PATH="${MSVCPATHFORBUILDING}:$PATH" # make sure MSVC link.exe is found (not bash/unix 'link' tool)
else
  makecmd="make"
  MYAPP_EXTRA_CONF=()
  # adding this next line here (rather than in run_all_tests.sh), because we think
  # of the graph-generation as more of a "build" step than a "test":
  "${DIR}"/sw_arch_doc/generate_graph.sh -s "${DIR}"/src/ -f "${DIR}"/ -x "${DIR}"/sw_arch_doc/excludes.txt

  # Next step done here (rather than inside generate_graph.sh) because the
  # graph script does not need to be "git aware".
  sw_arch_changed=$(git diff --exit-code "${DIR}"/sw_arch_doc/all_src.dot || true)
  if [[ -z ${sw_arch_changed} ]]; then
      # What this block achieves is:
      #
      # If the '*.dot' file was not actually changed, then we FORCE the svg to
      # also be in an unchanged state.
      #
      # This solves a problem where the svg can always come up dirty if a
      # contributor is running the build script but the version of graphviz/dot
      # on that contributor's build machine is not an exact match for the
      # graphviz/dot version used by whoever caused the most recent changes in
      # sw_arch_doc/.
      git checkout "${DIR}"/sw_arch_doc/all_src.svg
  fi
fi

"${DIR}"/tools/ci/version.sh "${chosen_folder}"

# shellcheck disable=SC1091 # path_to_qmake.bash was not specified as input
source "${DIR}"/path_to_qmake.bash

if [[ -n ${MYAPP_TEMPLATE_COMPILERCHOICE_CLANG-} ]]; then
  clang -v # to print info into CI log.
  MYAPP_EXTRA_CONF+=( "-Dwants_clang=ON" )
fi

mkdir -p "${chosen_folder}"
pushd "${chosen_folder}"

  # Note that CMAKE_BUILD_TYPE=Debug is silently ignored by Xcode (and others).
  # Refer to: https://github.com/219-design/qt-qml-project-template-with-ci/blob/main/OUR_CMAKE_USAGE_GUIDELINES.md#avoid-unigenerator-assumption
  # And: https://github.com/219-design/qt-qml-project-template-with-ci/blob/main/OUR_CMAKE_USAGE_GUIDELINES.md#always-supply-a-buildtype-at-command-line
  cmake \
    ${MYAPP_EXTRA_CONF[@]} \
    -DCMAKE_BUILD_TYPE:STRING="${chosen_buildtype}" \
    -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
    -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=ON \
    "${DIR}"

  ${makecmd} ${MYAPP_JOBS}

  # TODO
  #${makecmd} install # puts necessary items side-by-side with app exe

  # TODO?
  #if [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
  #  ${makecmd} debug
  #fi

  mkdir -p compiler_info_artifacts # <-- a github action in CI looks for this path
  date_fileprefix=$(date +"%Y-%m-%d_%H%M%S")
  output_jsonfile=compiler_info_artifacts/"${date_fileprefix}.${chosen_buildtype}".sorted_compile_commands.json
  # Works on Linux, Mac, and Windows as long as you have `jq`:
  "${CUR_GUICODE_ROOT}"/tools/formatters/write_sorted_json.sh \
    compile_commands.json \
    "${output_jsonfile}"

  if [[ -n ${UTILS_WE_ARE_RUNNING_IN_CI-} ]]; then
    # In CI, let's dump this info into the log. (Admittedly, it is on-the-whole
    # redundant with prior cmake commands in the log, but at least now it is sorted,
    # and it should also be 'ungarbled', as opposed to when the build executed, since
    # execution can be parallelized.)
    cat "${output_jsonfile}"
  fi

popd # pushd "${chosen_folder}"

if [[ -n ${MYAPP_TEMPLATE_BUILD_ANDROID-} ]]; then
  tools/ci/get_android_toolchain.sh
  tools/ci/build_android_app.sh "${chosen_folder}"/for_android "CONFIG+=force_debug_info"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  # Once we get around to implementing this, we _must_ revisit the comment
  # block in `run_all_tests.sh` tagged with "mac-release-build-nice-to-have".
  true
  #pushd cbuild/src/app
  #  macdeployqt app.app        -no-strip -libpath=$PWD -qmldir=../../../src/
  #  macdeployqt lib_tests.app  -no-strip -libpath=$PWD -qmldir=../../../src/
  #  macdeployqt util_tests.app -no-strip -libpath=$PWD -qmldir=../../../src/
  #popd # pushd cbuild/src/app

  #./build_ios_app.sh
fi

if [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
  # TODO? release?
  #windows_deploy "--release" ${EXEDIR} ${PLUGINDIR} ${SHIPDIR}

  EXEDIRDBG="${chosen_folder}"/stage
  PLUGINDIRDBG="${chosen_folder}"/stage
  SHIPDIRDBG="${chosen_folder}"/windeployfolder_debug

  #windows_deploy "--release" ${EXEDIR} ${PLUGINDIR} ${SHIPDIR}
  windows_deploy "--debug" "${EXEDIRDBG}" "${PLUGINDIRDBG}" "${SHIPDIRDBG}"

fi

echo 'We assume this was run with '\''set -e'\'' (look at upper lines of this script).'
echo 'Assuming so, then getting here means:'
# shellcheck disable=SC2154 # u_green and u_resetcolor come from utils.bash
echo "${u_green}build_cmake_app.sh SUCCESS${u_resetcolor}"
