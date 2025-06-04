!include($$top_srcdir/compiler_flags.pri) { error() }

QT += core

TEMPLATE = lib
!ios {
  CONFIG += shared
}
win32 {
    CONFIG -= shared
    CONFIG += staticlib
}

TARGET  = testmain

SOURCES += \
    test_main.cc

!include(../../third_party/googletest-release-1.11.0/googlemock/googlemock.pri) { error() }
!include(../../third_party/googletest-release-1.11.0/googletest/googletest.pri) { error() }

target.path = $$top_exe_dir
INSTALLS += target
