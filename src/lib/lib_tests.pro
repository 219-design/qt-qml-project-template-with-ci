include($$top_srcdir/compiler_flags.pri)

QT += core

SOURCES += \
    navigation_test.cc

# 'pri' usage based on http://archive.is/https://www.toptal.com/qt/vital-guide-qmake
include(./lib.pri)
include(../libtests/libtestmain.pri)
include(../../third_party/googletest-release-1.8.0_install_ubuntu18/googletest.pri)

target.path = $$top_exe_dir
INSTALLS += target
