QT += core

TEMPLATE = lib
CONFIG += shared

RESOURCES = libresources.qrc

SOURCES += \
    lib.cc \
    resources.cc

HEADERS += \
    lib.h \
    resources.h


target.path = $$top_builddir/app
INSTALLS += target
