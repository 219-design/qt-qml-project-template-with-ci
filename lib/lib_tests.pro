QT += core

SOURCES += \
    navigation_test.cc

# 'pri' usage based on http://archive.is/https://www.toptal.com/qt/vital-guide-qmake
include(./lib.pri)
include(../libtests/libtestmain.pri)
include(../third_party/googletest-release-1.8.0_install_ubuntu18/googletest.pri)

unix:{
    # So the exe will launch if we put all our '*.so' dylibs side-by-side with it.
    # Based on https://stackoverflow.com/a/27393241/10278
    QMAKE_LFLAGS += "-Wl,-rpath,\'\$$ORIGIN\'"
}
