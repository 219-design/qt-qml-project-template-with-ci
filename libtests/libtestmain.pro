QT += core

TEMPLATE = lib
CONFIG += shared

TARGET  = testmain

SOURCES += \
    test_main.cc

include(../third_party/googletest-release-1.8.0_install_ubuntu18/googletest.pri)

target.path = $$top_builddir/app
INSTALLS += target
