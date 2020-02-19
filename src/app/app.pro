!include($$top_srcdir/compiler_flags.pri) { error() }

QT += core qml

SOURCES += \
    gui_tests.cc \
    main.cc \
    qml_message_interceptor.cc \
    view_model_collection.cc

HEADERS += \
    gui_tests.h \
    qml_message_interceptor.h \
    view_model_collection.h

# 'pri' usage based on http://archive.is/https://www.toptal.com/qt/vital-guide-qmake
!include(../lib/lib.pri) { error() }
!include(../libstyles/libstyles.pri) { error() }
