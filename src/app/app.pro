include($$top_srcdir/compiler_flags.pri)

QT += core qml

SOURCES += \
    main.cc \
    qml_message_interceptor.cc \
    view_model_collection.cc

HEADERS += \
    qml_message_interceptor.h \
    view_model_collection.h

# 'pri' usage based on http://archive.is/https://www.toptal.com/qt/vital-guide-qmake
include(../lib/lib.pri)
include(../libstyles/libstyles.pri)
