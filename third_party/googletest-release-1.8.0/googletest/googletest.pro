include($$top_srcdir/compiler_flags.pri)

# relax some of the checks that compiler_flags.pri normally enables:
QMAKE_CXXFLAGS += "\
    -Wno-error=duplicated-branches \
    -Wno-error=missing-declarations \
    -Wno-error=null-dereference \
    -Wno-error=suggest-attribute=format \
    -Wno-error=suggest-attribute=noreturn \
    -Wno-error=switch-default \
    -Wno-error=switch-enum \
    -Wno-error=undef \
    "

TEMPLATE = lib
CONFIG += shared

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
