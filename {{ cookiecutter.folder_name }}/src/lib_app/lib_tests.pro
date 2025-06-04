!include($$top_srcdir/compiler_flags.pri) { error() }

QT += core

SOURCES += \
    navigation_test.cc

# 'pri' usage based on http://archive.is/https://www.toptal.com/qt/vital-guide-qmake
!include(./lib.pri) { error() }
!include(../libtests/libtestmain.pri) { error() }
!include(../../third_party/googletest-release-1.11.0/googlemock/googlemock.pri) { error() }
!include(../../third_party/googletest-release-1.11.0/googletest/googletest.pri) { error() }

target.path = $$top_exe_dir
INSTALLS += target
