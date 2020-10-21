# 'pri' usage based on http://archive.is/https://www.toptal.com/qt/vital-guide-qmake

!include($$top_srcdir/cross_platform.pri) { error() }

!win32 {
QMAKE_CXXFLAGS += -isystem $${top_srcdir}/third_party/googletest-release-1.8.0/googlemock/include
} else {
INCLUDEPATH += $${top_srcdir}/third_party/googletest-release-1.8.0/googlemock/include
}

LIBS += -L$$shadowed($$PWD)/$${win_build_folder_subdir} -lgooglemock$${our_android_lib_suffix}
