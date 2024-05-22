include($$top_srcdir/compiler_flags.pri)

!win32 {
# relax some of the checks that compiler_flags.pri normally enables:
linux:!android {
  !wants_clang {
    QMAKE_CXXFLAGS += "\
        -Wno-error=duplicated-branches \
        -Wno-error=suggest-attribute=format \
        -Wno-error=suggest-attribute=noreturn \
        "
  }

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
    src/gtest-all.cc

INCLUDEPATH += include

target.path = $$top_exe_dir
INSTALLS += target
