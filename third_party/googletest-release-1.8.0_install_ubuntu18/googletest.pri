# 'pri' usage based on http://archive.is/https://www.toptal.com/qt/vital-guide-qmake

INCLUDEPATH += $${top_srcdir}/third_party/googletest-release-1.8.0_install_ubuntu18/usr/local/include
LIBS += -L$${top_srcdir}/third_party/googletest-release-1.8.0_install_ubuntu18/usr/local/lib -lgmock -lgtest
