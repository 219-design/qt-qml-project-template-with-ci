!include($$top_srcdir/compiler_flags.pri) { error() }

QT += core qml quick svg widgets

win32 {
	DEFINES += LIBSTYLES_LIBRARY
}

TEMPLATE = lib
CONFIG += plugin

!win32 {
  DESTDIR = imports/libstyles
}
TARGET  = libstylesplugin

RESOURCES += \
    imports/libstyles/libstyles.qrc

SOURCES += \
    resource_helper.cc \
    resources.cc

HEADERS += \
    resource_helper.h \
    resources.h


target.path = $$top_exe_dir

INSTALLS += target
