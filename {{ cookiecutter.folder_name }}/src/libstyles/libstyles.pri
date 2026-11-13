# 'pri' usage based on http://archive.is/https://www.toptal.com/qt/vital-guide-qmake

!include($$top_srcdir/cross_platform.pri) { error() }

INCLUDEPATH += $${top_srcdir}
win32{
  LIBS += -L$$shadowed($$PWD)/$${win_build_folder_subdir}
}
!win32{
  LIBS += -L$$shadowed($$PWD)/imports/libstyles
}
LIBS += -llibstylesplugin$${our_android_lib_suffix}
