# 'pri' usage based on http://archive.is/https://www.toptal.com/qt/vital-guide-qmake

!include($$top_srcdir/cross_platform.pri) { error() }

INCLUDEPATH += $${top_srcdir}
LIBS += -L$$shadowed($$PWD)/$${win_build_folder_subdir} -ltestmain$${our_android_lib_suffix}
