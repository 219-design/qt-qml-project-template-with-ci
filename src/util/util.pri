# 'pri' usage based on http://archive.is/https://www.toptal.com/qt/vital-guide-qmake

INCLUDEPATH += $${top_srcdir}
LIBS += -L$$shadowed($$PWD) -lutil
