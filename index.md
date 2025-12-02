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
- [Publish compile\_commands.json as a CI build artifact](https://github.com/219-design/qt-qml-project-template-with-ci/blob/4b02a48/.github/workflows/cmakebuild_linux.yml#L54-L67)

### Check Code Coverage

- Enable compiler code coverage instrumentation and generate `.html` code coverage reports (for some build types).
   - Building with coverage instrumentation is [supported (and enabled automatically) for CMake debug builds with either Clang or GCC compilers](https://github.com/219-design/qt-qml-project-template-with-ci/blob/699819e859fe3251bd15d63add08e19aa52bf282/CMakeLists.txt#L103).
      - The GCC case uses [`gcov`](https://gcc.gnu.org/onlinedocs/gcc/Gcov.html) for coverage and [`gcovr`](https://gcovr.com/) for report generation.
      - The Clang case uses [Clang Source-based Code Coverage](https://clang.llvm.org/docs/SourceBasedCodeCoverage.html) for coverage and report generation.
         - We use Clang's native "source-based" coverage to give an example of using it and for a second angle on coverage, but note Clang advertises some "`gcov`-compatibility" options that might be worth exploring in multi-compiler situations where sharing coverage-processing code and report formats is preferred to having more perspectives.
   - `run_all_tests.sh` [generates `.html` code coverage reports for those supported build types](https://github.com/219-design/qt-qml-project-template-with-ci/blob/699819e859fe3251bd15d63add08e19aa52bf282/run_all_tests.sh#L92).
      - These reports are put in sub-directories with timestamp names, created within `coverage_reports/clang-llvm` and `coverage_reports/gcc-gcov` for Clang and GCC builds, respectively.
      - Within each timestamp-named sub-directory, you can open `index.html` to view the report summary. Following hyperlinks from there, you can find per-directory reports and per-file reports that show exactly which lines are covered.
   - For each supported `run_all_tests.sh` run in CI, [the generated](https://github.com/219-design/qt-qml-project-template-with-ci/blob/699819e859fe3251bd15d63add08e19aa52bf282/.github/workflows/cmakebuild_linux.yml#L42) [coverage reports](https://github.com/219-design/qt-qml-project-template-with-ci/blob/699819e859fe3251bd15d63add08e19aa52bf282/.github/workflows/cmakebuild_linux.yml#L59) [are saved](https://github.com/219-design/qt-qml-project-template-with-ci/blob/699819e859fe3251bd15d63add08e19aa52bf282/.github/workflows/cmakebuild_linux.yml#L93) [as an artifact](https://github.com/219-design/qt-qml-project-template-with-ci/blob/699819e859fe3251bd15d63add08e19aa52bf282/.github/workflows/main.yml#L44).

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
