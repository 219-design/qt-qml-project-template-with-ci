include($$top_srcdir/compiler_flags.pri)

QT += core

TEMPLATE = lib
CONFIG += shared

RESOURCES = libresources.qrc

SOURCES += \
    lib.cc \
    resource_helper.cc \
    resources.cc

HEADERS += \
    lib.h \
    resource_helper.h \
    resources.h

# 'pri' usage based on http://archive.is/https://www.toptal.com/qt/vital-guide-qmake
include(../libstyles/libstyles.pri)

target.path = $$top_exe_dir
INSTALLS += target
