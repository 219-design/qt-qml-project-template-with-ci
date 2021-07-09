include($$top_srcdir/compiler_flags.pri)

!win32 {
# relax some of the checks that compiler_flags.pri normally enables:
linux:!android {
    QMAKE_CXXFLAGS += "\
        -Wno-error=duplicated-branches \
        -Wno-error=suggest-attribute=format \
        -Wno-error=suggest-attribute=noreturn \
        "

  greaterThan(QT_MAJOR_VERSION, 5) {
    QMAKE_CXXFLAGS += "\
        -Wno-error=deprecated-copy \
        "
  }
}

linux:android {
    QMAKE_CXXFLAGS += "\
        -Wno-error=format-nonliteral \
        -Wno-error=missing-noreturn \
        "
}

# relax some of the checks that compiler_flags.pri normally enables:
QMAKE_CXXFLAGS += "\
    -Wno-error=conversion \
    -Wno-error=missing-declarations \
    -Wno-error=null-dereference \
    -Wno-error=switch-default \
    -Wno-error=switch-enum \
    -Wno-error=undef \
    "
}

TEMPLATE = lib
!ios {
  CONFIG += shared
}
win32 {
    CONFIG -= shared
    CONFIG += staticlib

    QMAKE_CXXFLAGS += "\
       /wd4514 \
       /wd4061 \
       "
}

SOURCES += \
    src/gtest-all.cc \
    src/gtest-death-test.cc \
    src/gtest-filepath.cc \
    src/gtest-port.cc \
    src/gtest-printers.cc \
    src/gtest-test-part.cc \
    src/gtest-typed-test.cc \
    src/gtest.cc

HEADERS += \
    include/gtest/gtest-death-test.h \
    include/gtest/gtest-message.h \
    include/gtest/gtest-param-test.h \
    include/gtest/gtest-printers.h \
    include/gtest/gtest-spi.h \
    include/gtest/gtest-test-part.h \
    include/gtest/gtest-typed-test.h \
    include/gtest/gtest.h \
    include/gtest/gtest_pred_impl.h \
    include/gtest/gtest_prod.h \
    include/gtest/internal/custom/gtest-port.h \
    include/gtest/internal/custom/gtest-printers.h \
    include/gtest/internal/custom/gtest.h \
    include/gtest/internal/gtest-death-test-internal.h \
    include/gtest/internal/gtest-filepath.h \
    include/gtest/internal/gtest-internal.h \
    include/gtest/internal/gtest-linked_ptr.h \
    include/gtest/internal/gtest-param-util-generated.h \
    include/gtest/internal/gtest-param-util.h \
    include/gtest/internal/gtest-port-arch.h \
    include/gtest/internal/gtest-port.h \
    include/gtest/internal/gtest-string.h \
    include/gtest/internal/gtest-tuple.h \
    include/gtest/internal/gtest-type-util.h \
    src/gtest-internal-inl.h

INCLUDEPATH += include

target.path = $$top_exe_dir
INSTALLS += target
