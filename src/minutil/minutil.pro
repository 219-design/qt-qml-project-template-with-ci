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
    logger.cc \
    x_unistd.cc

INCLUDEPATH += $${top_srcdir}

target.path = $$top_exe_dir
INSTALLS += target
