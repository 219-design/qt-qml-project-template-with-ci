!include($$top_srcdir/compiler_flags.pri) { error() }

QT += core qml quick svg widgets quickcontrols2

SOURCES += \
    event_filter.cc \
    gui_tests.cc \
    main.cc \
    view_model_collection.cc

HEADERS += \
    event_filter.h \
    gui_tests.h \
    view_model_collection.h

INCLUDEPATH += $${top_srcdir}/build/generated_files # for version.h

# 'pri' usage based on http://archive.is/https://www.toptal.com/qt/vital-guide-qmake
!include(../lib_app/lib.pri) { error() }
!include(../libstyles/libstyles.pri) { error() }
!include(../minutil/minutil.pri) { error() }
!include(../util/util.pri) { error() }

# QML_ROOT_PATH needed for the android deployment to scan ALL our qml files
QML_ROOT_PATH += \
    $${top_srcdir}/src

android {
    QT += androidextras

    DISTFILES += \
        $$top_srcdir/src/lib_app/android/AndroidManifest.xml

    ANDROID_PACKAGE_SOURCE_DIR = $$top_srcdir/src/lib_app/android
}

ios {
    QMAKE_INFO_PLIST = $$top_srcdir/src/app/ios/Info.plist

    # Other ios/xcode things your app MAY eventually need to configure here:
    # QMAKE_ASSET_CATALOGS += $$top_srcdir/src/lib_app/ios/Assets.xcassets

    # Q_ENABLE_BITCODE.name = ENABLE_BITCODE
    # Q_ENABLE_BITCODE.value = NO
    # QMAKE_MAC_XCODE_SETTINGS += Q_ENABLE_BITCODE
}
