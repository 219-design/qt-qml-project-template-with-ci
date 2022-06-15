!include($$top_srcdir/compiler_flags.pri) { error() }

QT += core qml quick svg widgets

TEMPLATE = lib
!ios {
  CONFIG += shared
}

win32 {
    CONFIG -= shared
    CONFIG += staticlib
}

RESOURCES = libresources.qrc

SOURCES += \
    cli_options.cc \
    lib.cc \
    logging_tags.cc \
    resources.cc

android {
    QT += androidextras

    SOURCES += \
        android/intent_to_email.cc
}

ios {
    SOURCES += ios/ios_log_redirect.mm
} else {
    SOURCES += ios/ios_log_redirect.cc
}

HEADERS += \
    cli_options.h \
    ios/ios_log_redirect.h \
    lib.h \
    logging_tags.h \
    resources.h

# Include all dependencies to both link in their libraries and include their headers.
!include(./lib_deps.pri) { error() }

TARGET = appimpl

target.path = $$top_exe_dir
INSTALLS += target
