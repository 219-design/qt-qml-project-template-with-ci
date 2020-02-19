include($$top_srcdir/compiler_flags.pri)

# relax some of the checks that compiler_flags.pri normally enables:
QMAKE_CXXFLAGS += "\
    -Wno-error=conversion \
    -Wno-error=duplicated-branches \
    -Wno-error=missing-declarations \
    -Wno-error=suggest-attribute=format \
    -Wno-error=suggest-attribute=noreturn \
    -Wno-error=switch-default \
    -Wno-error=switch-enum \
    -Wno-error=undef \
    "

TEMPLATE = lib
CONFIG += shared

SOURCES += \
    src/gmock-all.cc \
    src/gmock-cardinalities.cc \
    src/gmock-internal-utils.cc \
    src/gmock-matchers.cc \
    src/gmock-spec-builders.cc \
    src/gmock.cc

HEADERS += \
    include/gmock/gmock-actions.h \
    include/gmock/gmock-cardinalities.h \
    include/gmock/gmock-generated-actions.h \
    include/gmock/gmock-generated-function-mockers.h \
    include/gmock/gmock-generated-matchers.h \
    include/gmock/gmock-generated-nice-strict.h \
    include/gmock/gmock-matchers.h \
    include/gmock/gmock-more-actions.h \
    include/gmock/gmock-more-matchers.h \
    include/gmock/gmock-spec-builders.h \
    include/gmock/gmock.h

INCLUDEPATH += include

# 'pri' usage based on http://archive.is/https://www.toptal.com/qt/vital-guide-qmake
!include(../googletest/googletest.pri) { error() }

target.path = $$top_exe_dir
INSTALLS += target
