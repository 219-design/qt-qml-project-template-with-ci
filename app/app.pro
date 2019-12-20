QT += core qml

SOURCES += \
    main.cc

# 'pri' usage based on http://archive.is/https://www.toptal.com/qt/vital-guide-qmake
include(../lib/lib.pri)
include(../libstyles/libstyles.pri)

unix:{
    # So the exe will launch if we put all our '*.so' dylibs side-by-side with it.
    # Based on https://stackoverflow.com/a/27393241/10278
    QMAKE_LFLAGS += "-Wl,-rpath,\'\$$ORIGIN\'"
}
