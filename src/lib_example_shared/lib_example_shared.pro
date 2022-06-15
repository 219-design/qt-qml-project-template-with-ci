!include($$top_srcdir/compiler_flags.pri) { error() }

#QT += core

TEMPLATE = lib
!ios {
  CONFIG += shared
}

win32 {
    CONFIG -= shared
    CONFIG += staticlib
}

SOURCES += \
    example_shared.cc

HEADERS += \
    example_shared.h


INCLUDEPATH += $${top_srcdir}

target.path = $$top_exe_dir
INSTALLS += target
