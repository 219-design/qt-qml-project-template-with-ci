!include($$top_srcdir/compiler_flags.pri) { error() }
!include($$top_srcdir/android.pri) { error() }

INCLUDEPATH += $${top_srcdir}

LIBS += -L$$shadowed($$PWD) -lminutil$${our_android_lib_suffix}
