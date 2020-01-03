include($$top_srcdir/compiler_flags.pri)

QT += core qml

SOURCES += \
    main.cc \
    view_model_collection.cc

HEADERS += \
    view_model_collection.h

# 'pri' usage based on http://archive.is/https://www.toptal.com/qt/vital-guide-qmake
include(../lib/lib.pri)
include(../libstyles/libstyles.pri)

unix:{
    # So the exe will launch if we put all our '*.so' dylibs side-by-side with it.
    # Based on https://stackoverflow.com/a/27393241/10278
    QMAKE_LFLAGS += "-Wl,-rpath,\'\$$ORIGIN\'"
}
