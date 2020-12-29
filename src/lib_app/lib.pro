!include($$top_srcdir/compiler_flags.pri) { error() }

QT += core qml quick svg widgets

TEMPLATE = lib
!ios {
  CONFIG += shared
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

HEADERS += \
    cli_options.h \
    lib.h \
    logging_tags.h \
    resources.h

# 'pri' usage based on http://archive.is/https://www.toptal.com/qt/vital-guide-qmake
!include(../libstyles/libstyles.pri) { error() }
!include(../util/util.pri) { error() }

TARGET = appimpl

target.path = $$top_exe_dir
INSTALLS += target
