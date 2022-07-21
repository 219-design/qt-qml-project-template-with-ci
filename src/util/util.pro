!include($$top_srcdir/compiler_flags.pri) { error() }

QT += core

android {
    QT += androidextras
}

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
    am_i_inside_debugger.h \
    deleter_with_qt_deferred_deletion.h \
    every_so_often.h \
    timer_service.h \
    qml_list_property_helper.h \
    qml_message_interceptor.h \
    usage_log_t.hpp

target.path = $$top_exe_dir
INSTALLS += target
