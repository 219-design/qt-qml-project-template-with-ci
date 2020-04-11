## Qt/QML Project Template by 219 Design, LLC

A template for building a Qt/QML application with **many batteries included**,
such as:

 - project folder layout for creating one custom app that uses one or more of your custom libraries
 - clang-format checking of C++ code
 - qmlfmt checking of QML code
 - runtime "flexible asserts" to ensure you do not miss any QML runtime warnings
 - a wrapper script to make iterating on QML layouts painless with qmlscene
 - test-runner code to run any unit tests you add. (googletest is provided)
 - a basic '.github/workflow' to run tests on github for each commit
 - a basic GUI Test that launches the app in CI using Xvfb
 - automated Linux deployment via AppImage folder

The minimal application that this project initially builds is the demo app that
we originally blogged about at
https://www.219design.com/a-tale-of-efficient-keyboard-navigation-code-in-qml/

When using this template project, you can build that app once or twice to make
sure you understand the project structure. Then delete `main.qml` and replace it
with your own app (adding supporting C++ view model classes as you see fit).

Higher-level rationale was discussed in our [hello-world-template-toolchain blog
post.](https://www.219design.com/hello-world-template-toolchain/)

## How to build and launch the app

1. Use the operating system: Ubuntu 18.04 LTS "bionic"

2. Visually inspect the file `tools/ci/provision.sh` to learn which `apt`
   packages are required. Use your own preferred `apt` commands or equivalent
   methods to install those required packages. (`provision.sh` is executed on
   the github docker instance prior to running the continuous integration
   build-and-test routines)

3. In a terminal, run `build_app.sh`

4. Assuming step (3) was successful, you can launch the app at
   `./build/src/app/app`

   If the app fails with a message such as `qt.qpa.plugin: Could not
   load the Qt platform plugin "xcb" in
   "/home/daniel/Qt/5.14.0/gcc_64/plugins" even though it was found.`,
   you need to set `QT_QPA_PLATFORM_PLUGIN_PATH` to the correct
   location. And when you set that, you must ensure that
   `LD_LIBRARY_PATH` also points to the same Qt build.

        export QT_QPA_PLATFORM_PLUGIN_PATH="$(pwd)/build_qt_binaries/qt5_opt_install/plugins/platforms
        export LD_LIBRARY_PATH="$(pwd)/build_qt_binaries/qt5_opt_install/lib:$LD_LIBRARY_PATH"

5. (Optional) Assuming step (3) was successful, you can also invoke
   `run_all_tests.sh` to check that the binaries you built pass all their tests.

### Notes About Qt Version

This project includes pre-built Qt modules via a git submodule. This is one way to
satisfy projects that:
 - require building Qt from source (for any reason)
 - require excluding various Qt modules. (e.g. we have skipped qtpurchasing, qtspeech)
 - require assurance that all teammembers have precisely the same Qt binaries

Git submodules are not the only way to meet those requirements. It is simply the
approach employed here.

Because the Qt modules are included via submodule, you do not need to install Qt
before using this repository. Just follow "How to build" above.

### To Use Your Own Qt Version Instead

To use your own Qt version, simply edit `path_to_qmake.bash` as you see fit.
