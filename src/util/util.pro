!include($$top_srcdir/compiler_flags.pri) { error() }

QT += core

TEMPLATE = lib
CONFIG += shared

SOURCES += \
    qml_message_interceptor.cc

HEADERS += \
    qml_list_property_helper.h \
    qml_message_interceptor.h \
    version.h

target.path = $$top_exe_dir
INSTALLS += target
