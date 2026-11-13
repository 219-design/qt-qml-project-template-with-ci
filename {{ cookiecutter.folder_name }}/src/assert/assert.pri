# 'pri' usage based on http://archive.is/https://www.toptal.com/qt/vital-guide-qmake

!win32 {
  QMAKE_CXXFLAGS += -isystem $${top_srcdir}/src/assert
}

win32 {
  INCLUDEPATH += $${top_srcdir}/src/assert
}
