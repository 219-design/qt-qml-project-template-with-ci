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

There are two supported ways for you to begin your own project based off of
this repository. You need only choose one.

### Use via GitHub

Note: While GitHub indeed provides a one-click solution that will result in a
fully-functioning copy of this project, we nevertheless recommend the
Cookiecutter method (next section) due the flexibility it provides for renaming
the whole project (and C++ namespace) at once.

To use via GitHub, log in at github.com, visit this project's hompage
(https://github.com/219-design/qt-qml-project-template-with-ci), and click the
"Use this template" button in the GitHub web UI.

In response to your button click, GitHub will create a copy of this repo that is
owned by *your* GitHub account.

You then need to clone *your* new repo using [the normal GitHub procedures](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository).

You must also read "Your first commit" (below) before continuing further:

### Use via Cookiecutter

(Skip this section if you chose to click GitHub's "Use this template" button.)

Get [cookiecutter](https://cookiecutter.readthedocs.io/en/latest/).

Pull down our cookiecutter-ized branch using cookiecutter directly, like so:

```
cookiecutter https://github.com/219-design/qt-qml-project-template-with-ci --checkout origin/cookiecutter
```

Follow the cookiecutter prompts to provide your own project name and author
information. Doing so will customize the source files with your own
authorship/copyright information.

You must also read "Your first commit" (below) before continuing further:

### Your first commit:

Once either the GitHub "Use this template" button or cookiecutter has completed
its work, make sure you have `clang-format-10` installed:
```
sudo apt install clang-format-10
```

Then `cd` into the project directory and:

- If you used cookiecutter, then run:
```
./init_repo.sh
```

- If you used GitHub's "Use this template" button, then run:
```
cookiecutter/init_repo.sh
```

The final line of output from the `init_repo.sh` script will be:

> Examine git status to see if clang-format made changes.


Please do as it says, and run `git status` and choose to commit any clang
formatting changes.

After that, please proceed to "How to build" (below) before continuing further:

## How to build and launch the app

1. Use one of these operating systems:
     - Ubuntu 18.04 LTS "Bionic"
     - Mac OS X 10.15 "Catalina"
     - Windows 10; or Windows Server 2019 (**PLEASE SEE "Windows Notes" section, below**)

2. Run *one* of the following, depending on your host platform (the second one is for Mac OS X):
     - `tools/ci/provision.sh`
     - `tools/ci/provision_mac.sh`
     - `tools/ci/provision_win.sh`

   Do *not* run as root, but *do* be prepared to enter a sudoer password when
   prompted. Visually inspect the file `tools/ci/provision.sh` (or
   `provision_mac.sh`) to learn which `apt` (or `homebrew`) packages are
   required. If you prefer to install the required libraries via other means,
   then feel free to use your own preferred `apt` commands or equivalent methods
   to install those required packages.  (`provision.sh` is executed in the
   GitHub action runner instance prior to running the continuous integration
   build-and-test routines. We know that it works well there.)

3. (Optional) To enable the Android build and/or the linuxdeployqt step, you can
   set the following variables before proceeding. This will add several minutes
   to the build time, so only enable it if you need to.

    - `export MYAPP_TEMPLATE_BUILD_ANDROID=1 # optional`
    - `export MYAPP_TEMPLATE_BUILD_APPIMAGE=1 # optional`

4. In a terminal, run `./build_app.sh`

5. Assuming step (4) was successful, you can launch the app at
   `./build/src/app/app` (or on Windows: `start build/windeployfolder/app.exe`)

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

### Windows Notes

#### "Pre pre bootstrap" actions

This project is designed to mostly bootstrap itself.

For example, you are **not** expected to install Qt before interacting with this
project. This project contains provisioning scripts to do that for you.

However, on Windows in particular, there are a small set of tasks you must do
manually before interacting with this project.

There are three fundamental tools you must obtain manually:

 - Python 3 for Windows
 - Git for Windows (Msys based git). https://git-scm.com/download/win
 - Microsoft C++ Build Tools for Visual Studio 2019
    - Note: The full-blown VS IDE is optional. The mandatory items are simply the tools (`cl.exe`, `nmake`, etc)

Once you manually install Python, Git, and the MSVC Tools, you can perform a
scripted build of this project in a terminal. To configure the terminal, you
must initialize a basic cmd.exe prompt with `vcvars64.bat`, then instantiate the
git-bash (msys `bash.exe`) instance nested therein.

To see how this 'nested terminals' approach can be automated, refer to this
project's github CI config:

  - [.github/workflows/windows.yml](https://github.com/219-design/qt-qml-project-template-with-ci/blob/c1efff507a/.github/workflows/windows.yml#L20)

To clarify what this cmd.exe/git-bash dance looks like when you perform it
interactively, here is a video:

  - https://drive.google.com/file/d/1UjC7wvUYnS6PEzhMfLWpKRsBrYK-UUAo
     - (TODO: as of Feb 2021, we could benefit from making an even better video demo.)


### Notes About Qt Version

The build scripts of this project download pre-built Qt modules using
[aqtinstall](https://github.com/miurahr/aqtinstall) on Linux and a local copy of
the [script provided by Qbs](https://github.com/qbs/qbs/blob/495d7767af8/scripts/install-qt.sh)
on Mac OS X.

Because the Qt modules are downloaded during the build, you do not need to
install Qt before using this repository. Just follow "How to build" above.

### To Use Your Own Qt Version Instead

To use your own Qt version, simply edit `path_to_qmake.bash` as you see fit.
