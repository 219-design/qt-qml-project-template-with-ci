!include($$top_srcdir/compiler_flags.pri) { error() }

QT += core

SOURCES += \
    tests/example_shared_test.cc

# 'pri' usage based on http://archive.is/https://www.toptal.com/qt/vital-guide-qmake
!include(./lib_example_shared.pri) { error() }
!include(../libtests/libtestmain.pri) { error() }

target.path = $$top_exe_dir
INSTALLS += target
