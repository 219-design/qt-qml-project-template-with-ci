!include($$top_srcdir/compiler_flags.pri) { error() }
!include($$top_srcdir/cross_platform.pri) { error() }

INCLUDEPATH += $${top_srcdir}

LIBS += -L$$shadowed($$PWD)/$${win_build_folder_subdir} -lminutil$${our_android_lib_suffix}

# PRE_TARGETDEPS is not needed on Linux because we do not use static libs on Linux.
win32 { # OS-specific because we must use full filename and OS-specific suffix
  # https://lists.qt-project.org/pipermail/interest/2017-June/027367.html
  PRE_TARGETDEPS += $$shadowed($$PWD)/$${win_build_folder_subdir}/minutil.lib
}
