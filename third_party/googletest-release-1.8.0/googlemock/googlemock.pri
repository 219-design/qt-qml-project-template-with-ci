# 'pri' usage based on http://archive.is/https://www.toptal.com/qt/vital-guide-qmake

!include($$top_srcdir/android.pri) { error() }

QMAKE_CXXFLAGS += -isystem $${top_srcdir}/third_party/googletest-release-1.8.0/googlemock/include
LIBS += -L$$shadowed($$PWD) -lgooglemock$${our_android_lib_suffix}
