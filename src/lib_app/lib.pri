# 'pri' usage based on http://archive.is/https://www.toptal.com/qt/vital-guide-qmake

!include($$top_srcdir/android.pri) { error() }

INCLUDEPATH += $${top_srcdir}
!win32 {
    LIBS += -L$$shadowed($$PWD) -lapp$${our_android_lib_suffix}
}

win32 {
	LIBS += -L$$sahdowed($$PWD)/release -lapp$${our_android_lib_suffix}
}
