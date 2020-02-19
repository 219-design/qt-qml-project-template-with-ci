!include($$top_srcdir/compiler_flags.pri) { error() }

QT += core

TEMPLATE = lib
CONFIG += shared

TARGET  = testmain

SOURCES += \
    test_main.cc

!include(../../third_party/googletest-release-1.8.0/googlemock/googlemock.pri) { error() }
!include(../../third_party/googletest-release-1.8.0/googletest/googletest.pri) { error() }

target.path = $$top_exe_dir
INSTALLS += target
