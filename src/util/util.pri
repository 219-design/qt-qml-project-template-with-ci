# 'pri' usage based on http://archive.is/https://www.toptal.com/qt/vital-guide-qmake

!include($$top_srcdir/cross_platform.pri) { error() }

# Explicitly don't include a dependencies file as this is a minimal library.

# Add the include path so any users can reference the headers.
INCLUDEPATH += $${top_srcdir}

# Link the libraries in so that the library can be referenced during link time.
LIBS += -L$$shadowed($$PWD)/$${win_build_folder_subdir} -lutil$${our_android_lib_suffix}

# Add the build directory as an rpath so that the .so can be found at runtime.
QMAKE_LFLAGS += "-Wl,-rpath,\'$$shadowed($$PWD)/$${win_build_folder_subdir}\'"

# PRE_TARGETDEPS is not needed on Linux because we do not use static libs on Linux.
win32 { # OS-specific because we must use full filename and OS-specific suffix
  # https://lists.qt-project.org/pipermail/interest/2017-June/027367.html
  PRE_TARGETDEPS += $$shadowed($$PWD)/$${win_build_folder_subdir}/util.lib
}
