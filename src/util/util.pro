!include($$top_srcdir/compiler_flags.pri) { error() }

QT += core

TEMPLATE = lib
CONFIG += shared

#SOURCES += \

HEADERS += \
    qml_list_property_helper.h \
    version.h

target.path = $$top_exe_dir
INSTALLS += target
