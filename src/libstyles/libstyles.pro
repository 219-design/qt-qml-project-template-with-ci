!include($$top_srcdir/compiler_flags.pri) { error() }

QT += core qml quick

TEMPLATE = lib
CONFIG += plugin

DESTDIR = imports/libstyles
TARGET  = libstylesplugin

RESOURCES += \
    imports/libstyles/libstyles.qrc

SOURCES += \
    resources.cc

HEADERS += \
    resources.h


target.path = $$top_exe_dir

INSTALLS += target
