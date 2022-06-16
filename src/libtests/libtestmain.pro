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

!include(./libtestmain_deps.pri) { error() }

target.path = $$top_exe_dir
INSTALLS += target
