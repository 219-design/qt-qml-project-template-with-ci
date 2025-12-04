#!/bin/bash

#
# Copyright (c) 2020, 219 Design, LLC
# See LICENSE.txt
#
# https://www.219design.com
# Software | Electrical | Mechanical | Product Design
#

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

if [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
  if [[ -z ${VCToolsInstallDir-} ]]; then
    echo "WHOOPS. vcvars64 (or vcvarsall) was not called yet."
    echo "You MUST start a VISUAL STUDIO command prompt. (Then start git-bash from within it.)"
    echo "Read the above and try again."
    exit 1
  fi
fi

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "${THISDIR}/tools/ci/rootdirhelper.bash"
source ${THISDIR}/tools/ci/utils.bash # will compute UTILS_WE_ARE_RUNNING_IN_CI

if [[ -n ${UTILS_WE_ARE_RUNNING_IN_CI-} ]];
# The '-' hyphen above tests without angering the 'set -u' about unbound variables
then
  echo "C.I. environment was detected."

  # Try various ways to print OS version info.
  # This lets us keep a record of this in our CI logs,
  # in case the CI docker images change.
  uname -a       || true
  lsb_release -a || true
  gcc --version  || true  # oddly, gcc often prints great OS information
  cat /etc/issue || true

  # What environment variables did the C.I. system set? Print them:
  env

  ./tools/ci/provision.sh
  git submodule update --init # avoid '--recursive' (as long as we can) due to inner qmlfmt deps

  XDISPLAY=":1"
else
  echo "Assuming we are NOT on bitbucket. Did not find BITBUCKET_REPO_OWNER nor BITBUCKET_REPO_FULL_NAME in env."
  XDISPLAY=""
fi

if [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
  #tools/formatters/enforce_qml_format.sh ${THISDIR}/src check_only # TODO: qmlfmt on win32?
  tools/formatters/enforce_clang_format.sh ${THISDIR}/src check_only
else
  tools/formatters/enforce_qml_format.sh ${THISDIR}/src check_only
  tools/formatters/enforce_clang_format.sh ${THISDIR}/src check_only
fi

if [[ -n ${MYAPP_TEMPLATE_PREFER_QMAKE-} ]]; then
  ./build_app.sh
else
  # Run a Release build (except where it doesn't make sense)
  if [[ "$OSTYPE" != "darwin"* ]]; then
    # On Mac, we skip. (We could come up with something better at some point.)
    # Mac uses a cmake multi-generator, so it doesn't make sense to re-generate
    # the cmake (conceptual) 'makefile' outputs twice.
    # Additionally, Mac CI minutes are more precious than CI on other platforms.
    # This tag is referenced elsewhere in the repo: "mac-release-build-nice-to-have"
    ./build_cmake_app.sh Release
  fi

  ./build_cmake_app.sh  # <-- the default invocation (no args) will build debug.

  if [[ -z ${MYAPP_TEMPLATE_QT5-} ]]; then
    # Nice-to-have: figure out why cmake-qt6 moved `app` such that we now need this.
    ln -sf bin/app ${BUILDOUT_DBG}/stage/app
  fi
fi

# run all test binaries that got built in the expected dir:
tools/auto_test/run_cpp_auto_tests.sh

if [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
  ####################   EARLY EXIT FOR MICROSOFT WINDOWS.  (TODO: tools/gui_test for WIN32)
  tools/auto_test/process_coverage_data.sh
  echo 'EARLY EXIT FOR MICROSOFT WINDOWS.  (TODO: tools/gui_test for WIN32)'
  exit 0
fi

if [[ -n ${XDISPLAY-} ]]; then
  if [[ "$OSTYPE" != "darwin"* ]]; then
    # 'coproc' so that SIGINT will still work (https://unix.stackexchange.com/a/478697/11592)
    coproc Xvfb ${XDISPLAY} -screen 0 1024x768x16
    VIRT_FB_PID=$!
    sleep 4 # time to (probabilistically) ensure that Xvfb has started
  fi
fi

# Note: the naming requirements for "---suppressed_warnings.txt" can be found by
# reading the source code in: qml_message_interceptor.cc
# (Essentially, the name is based on QCoreApplication::applicationName)
# put our QML-warnings suppressions list where it can be found during testing:
cp tools/gui_test/app_qml_suppressed_warnings.txt /tmp/
if [[ "$OSTYPE" == "darwin"* ]]; then
  cp tools/gui_test/app_qml_suppressed_warnings.txt ${TMPDIR}/
fi

# run gui tests which execute the actual app binary:
tools/gui_test/launch_gui_for_display.sh "${XDISPLAY}"

tools/auto_test/process_coverage_data.sh

if [[ -n ${MYAPP_TEMPLATE_BUILD_APPIMAGE-} ]]; then
  # this MUST happen last because (on the C.I. server) it destroys folders (intentionally)
  tools/gui_test/test_AppImage.sh "${XDISPLAY}"
fi

if [[ -n ${XDISPLAY-} ]]; then
  if [[ "$OSTYPE" != "darwin"* ]]; then
    kill -SIGINT $VIRT_FB_PID
  fi
fi

echo 'We assume this was run with '\''set -e'\'' (look at upper lines of this script).'
echo 'Assuming so, then getting here means:'
echo "${u_green}run_all_tests SUCCESS${u_resetcolor}"
