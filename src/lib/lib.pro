include($$top_srcdir/compiler_flags.pri)

QT += core

TEMPLATE = lib
CONFIG += shared

RESOURCES = libresources.qrc

SOURCES += \
    cli_options.cc \
    lib.cc \
    logging_tags.cc \
    resource_helper.cc \
    resources.cc

HEADERS += \
    cli_options.h \
    lib.h \
    logging_tags.h \
    resource_helper.h \
    resources.h

# 'pri' usage based on http://archive.is/https://www.toptal.com/qt/vital-guide-qmake
include(../libstyles/libstyles.pri)
include(../util/util.pri)

target.path = $$top_exe_dir
INSTALLS += target
