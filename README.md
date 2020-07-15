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

## How to Start Using this Template Repository

There are two recommended ways for you to begin your own project based off of
this repository. You need only choose one.

### Use via GitHub

To use via GitHub, log in at github.com, visit this project's hompage
(https://github.com/219-design/qt-qml-project-template-with-ci), and click the
"Use this template" button in the GitHub web UI.

### Use via Cookiecutter

Get [cookiecutter](https://cookiecutter.readthedocs.io/).

Pull down our cookiecutter-ized branch using cookiecutter directly, like so:

```
cookiecutter https://github.com/219-design/qt-qml-project-template-with-ci --checkout origin/cookiecutter
```

Follow the cookiecutter prompts to provide your own project name and author
infomation. Doing so will customize the source files with your own information.

Once cookiecutter has completed its work, `cd` into the project directory and run:

```
./init_repo.sh
```

After that, please proceed to "How to build" (below) before continuing further:

## How to build and launch the app

1. Use one of these operating systems:
     - Ubuntu 18.04 LTS "Bionic"
     - Mac OS X 10.15 "Catalina"

2. Visually inspect the file `tools/ci/provision.sh` (or `provision_mac.sh`) to
   learn which `apt` (or `homebrew`) packages are required. Use your own
   preferred `apt` commands or equivalent methods to install those required
   packages.
   (`provision.sh` is executed in the GitHub action runner instance prior to
   running the continuous integration build-and-test routines. It may or may not
   be a provisioning script that you wish to run locally. Read it and choose.)

3. If you do not wish to build for Android, then you can avoid unnecessary
   lengthening of the build times by issuing:
   `export MYAPP_TEMPLATE_SKIP_ANDROID=1`

4. In a terminal, run `build_app.sh`

5. Assuming step (4) was successful, you can launch the app at
   `./build/src/app/app`

   For the iOS version of the app, one of the outputs of `build_app.sh` will be
   the xcodeproj. Open the xcodeproj in Xcode and from there you can choose a
   simulator or a device as the "Destination" and then choose "Run" (or command
   R). The xcodeproj is created at: `build/for_ios/src/app/app.xcodeproj`

   If the app fails with a message such as `qt.qpa.plugin: Could not
   load the Qt platform plugin "xcb" in
   "/home/daniel/Qt/5.15.0/gcc_64/plugins" even though it was found.`,
   you need to set `QT_QPA_PLATFORM_PLUGIN_PATH` to the correct
   location. And when you set that, you must ensure that
   `LD_LIBRARY_PATH` also points to the same Qt build.

        export QT_QPA_PLATFORM_PLUGIN_PATH="$(pwd)/dl_third_party/Qt_desktop/5.15.0/gcc_64/plugins/platforms
        export LD_LIBRARY_PATH="$(pwd)/dl_third_party/Qt_desktop/5.15.0/gcc_64/lib:$LD_LIBRARY_PATH"

6. (Optional) Assuming step (4) was successful, you can also invoke
   `run_all_tests.sh` to check that the binaries you built pass all their tests.

### Notes About Qt Version

The build scripts of this project download pre-built Qt modules using a local
copy of the
[script provided by Qbs](https://github.com/qbs/qbs/blob/495d7767af8/scripts/install-qt.sh).

Because the Qt modules are downloaded during the build, you do not need to
install Qt before using this repository. Just follow "How to build" above.

### To Use Your Own Qt Version Instead

To use your own Qt version, simply edit `path_to_qmake.bash` as you see fit.
