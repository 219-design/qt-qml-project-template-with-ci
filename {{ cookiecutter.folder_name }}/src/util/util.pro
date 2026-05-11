!include($$top_srcdir/compiler_flags.pri) { error() }

QT += core

TEMPLATE = lib
!ios {
  CONFIG += shared
}

win32 {
    CONFIG -= shared
    CONFIG += staticlib
}

SOURCES += \
    am_i_inside_debugger.cc \
    deleter_with_qt_deferred_deletion.cc \
    every_so_often.cc \
    timer_service.cc \
    qml_message_interceptor.cc

HEADERS += \
    timer_service.h

target.path = $$top_exe_dir
INSTALLS += target
