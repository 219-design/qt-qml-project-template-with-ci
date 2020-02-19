include($$top_srcdir/compiler_flags.pri)

QT += core

TEMPLATE = lib
CONFIG += shared

#SOURCES += \

HEADERS += \
    qml_list_property_helper.h

target.path = $$top_exe_dir
INSTALLS += target
