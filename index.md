# Repository Index

Here we list various individual files that we deem to be (more or less)
"cheatsheet ready" mini-nuggets scattered throughout the repository.

[Return to main README.md](README.md)

## Useful Reusable QML Code

- [ImageSvgHelper.qml](src/lib_app/qml/ImageSvgHelper.qml) to eliminate pixelated, badly scaled SVGs in your QML app.
   - Also see: https://github.com/219-design/qt-qml-project-template-with-ci/pull/32
- [DebugRect.qml](src/lib_app/qml/DebugRect.qml) for easy visual debugging of QML layout/anchor/sizing issues.
   - Also see: https://stackoverflow.com/questions/42343714/is-it-possible-to-show-qml-controls-boundaries/60641874#60641874

## Automated Method To Catch QML Runtime Warnings In CI

This involves five key steps:
   1. Launch the GUI in CI (with a workaround to adapt to lack of display/screen)
   2. Give your GUI app a command-line flag telling the app to shut itself down gracefully (to replace an interactive human user during CI).
   3. Install your own `QtMessageHandler` to inspect all warnings.
       * Note: a key insight here is that you will be inspecting qWarning log lines that are logged by the Qt framework itself.
   4. In your custom `QtMessageHandler`, abort the program (i.e. intentionally crash) if there arrives any qWarning that originated from a qml file.
   5. For a program that ran crash-free, inspect all of its output with a helper script just in case.

### Working code that performs the above steps:

- [Script using Xvfb to launch GUI in CI](https://github.com/219-design/qt-qml-project-template-with-ci/blob/b0abc1b/run_all_tests.sh#L90-L109)
- [Use of GuiTests helper class to gracefully close the app after qml was loaded/displayed](https://github.com/219-design/qt-qml-project-template-with-ci/blob/b0abc1b/src/app/view_model_collection.cc#L66)
- [Creation of command-line options](https://github.com/219-design/qt-qml-project-template-with-ci/blob/b0abc1b/src/lib_app/cli_options.cc#L14-L55)
- [QtMessageHandler to abort on any QML runtime warning](https://github.com/219-design/qt-qml-project-template-with-ci/blob/b0abc1b/src/util/qml_message_interceptor.cc#L129-L144)
- [Script to inspect application log file for QML issues](tools/gui_test/check_gui_test_log.py)
- [Use of log file inspection script](https://github.com/219-design/qt-qml-project-template-with-ci/blob/b0abc1b/tools/gui_test/launch_gui_for_display.sh#L33-L48)


## Audit The Codebase

### Visualize Code Dependencies

- [Standalone script to visually plot interdependencies in your C++ codebase](https://github.com/219-design/qt-qml-project-template-with-ci/tree/main/sw_arch_doc)

### Record And Track Compiler Flags

- [Generate compile\_commands.json during CMake build](https://github.com/219-design/qt-qml-project-template-with-ci/blob/b0abc1b/build_cmake_app.sh#L95-L118)
- [Publish compile\_commands.json as a CI build artifact](https://github.com/219-design/qt-qml-project-template-with-ci/blob/b0abc1b/.github/workflows/cmakebuild_linux.yml#L48-L61)

## Leverage Tools For Finding Warnings/Errors/UB/Bugs

- [Enable ASan in CMake Debug Build](https://github.com/219-design/qt-qml-project-template-with-ci/blob/b0abc1b/cmake_include/unix_settings.cmake#L44-L80)
   - Our approach includes:
      - How to "bake in" various ASan settings at compile-time.
      - How to make UBSan include a stacktrace.
      - Using ASAN_OPTIONS and UBSAN_OPTIONS environment variables when running tests.
      - Suppressing leak detection to run in gdb.
      - Suppressing LSan leak reports about third-party code (here: libfontconfig.so).
      - All made clear in this PR: https://github.com/219-design/qt-qml-project-template-with-ci/pull/130
- Maximize Compiler Warnings-as-Errors:
   - [Strong Compiler Settings - Unix](https://github.com/219-design/qt-qml-project-template-with-ci/blob/b0abc1b/cmake_include/unix_settings.cmake#L88-L131)
   - [Strong Compiler Settings - Windows](https://github.com/219-design/qt-qml-project-template-with-ci/blob/b0abc1b/cmake_include/win_msvc_settings.cmake#L3-L91)
