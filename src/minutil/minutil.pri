!include($$top_srcdir/compiler_flags.pri) { error() }
!include($$top_srcdir/cross_platform.pri) { error() }

INCLUDEPATH += $${top_srcdir}

LIBS += -L$$shadowed($$PWD)/$${win_build_folder_subdir} -lminutil$${our_android_lib_suffix}
