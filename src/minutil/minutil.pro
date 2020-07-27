!include($$top_srcdir/compiler_flags.pri) { error() }

#QT += core

TEMPLATE = lib
!ios {
    CONFIG += shared
}

SOURCES += \
    logger.cc

HEADERS += \
    logger.h


INCLUDEPATH += $${top_srcdir}

target.path = $$top_exe_dir
INSTALLS += target
