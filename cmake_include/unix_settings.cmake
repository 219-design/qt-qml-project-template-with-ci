if(UNIX)

  option(
    BUILD_SHARED_LIBS
    "Build using shared libraries"
    ON
  )

  set(CMAKE_POSITION_INDEPENDENT_CODE
      ON
  )

  # project-wide includes. add on 'isystem' path so they are 'immune' to
  # compiler warnings
  include_directories(
    SYSTEM
    ${PROJECT_SOURCE_DIR}/src/assert
  )

  if(NOT
     ANDROID
  )
    list(
      APPEND
      MYAPP_COMPILER_WARNINGS
      "-Werror"
    )

    if(NOT
       wants_clang
    )
      list(
        APPEND
        MYAPP_COMPILER_WARNINGS
        "-Wduplicated-branches"
        "-Wduplicated-cond"
        "-Wlogical-op"
        "-Wmisleading-indentation"
        "-Wrestrict"
        "-Wunused-but-set-parameter"
      )
    endif() # if (NOT wants_clang)
  endif() # if (NOT ANDROID)

  # some compiler warnings inspired by:
  # https://kristerw.blogspot.com/2017/09/useful-gcc-warning-options-not-enabled.html
  # others inspired by:
  # https://stackoverflow.com/questions/5088460/flags-to-enable-thorough-and-verbose-g-warnings
  list(
    APPEND
    MYAPP_COMPILER_WARNINGS
    "-Wall"
    "-Wcast-align"
    "-Wcast-qual"
    "-Wconversion"
    "-Wdisabled-optimization"
    # "-Wduplicated-branches -Wduplicated-cond" # conditionally added above
    "-Werror=switch"
    "-Wextra"
    "-Wfloat-equal"
    "-Wformat-nonliteral"
    "-Wformat-security"
    "-Wformat=2"
    "-Wimport"
    "-Winit-self"
    "-Winline"
    # "-Wlogical-op -Wmisleading-indentation" # conditionally added above
    "-Wmissing-declarations"
    "-Wmissing-field-initializers"
    "-Wmissing-format-attribute"
    "-Wmissing-include-dirs"
    "-Wmissing-noreturn"
    "-Wnon-virtual-dtor"
    "-Wnull-dereference"
    "-Wold-style-cast"
    "-Wpedantic"
    "-Wpointer-arith"
    "-Wredundant-decls"
    # "-Wrestrict" # conditionally added above
    "-Wshadow"
    "-Wstack-protector"
    "-Wswitch-default"
    "-Wswitch-enum"
    "-Wundef"
    "-Wuninitialized"
    "-Wunreachable-code"
    "-Wunused"
    # "-Wunused-but-set-parameter" # conditionally added above
    "-Wunused-parameter"
    "-Wvariadic-macros"
    "-Wwrite-strings"
  )

  # Do the 'no-' flags in their own statement, to ensure that they always happen
  # last:
  list(
    APPEND
    MYAPP_COMPILER_WARNINGS
    "-Wno-error=inline"
    "-Wno-error=deprecated-declarations"
  )
  # Rationale for 'Wno-error=inline' is that a failure to inline is information,
  # and never truly 'wrong'

  if(IOS
     OR MACOS
  )
    # Disable a couple that are more onerous to comply with on Mac
    list(
      APPEND
      MYAPP_COMPILER_WARNINGS
      "-Wno-error=missing-noreturn"
      "-Wno-error=sign-conversion"
    )
  endif() # if (IOS OR MACOS)

endif() # if (UNIX) ... this whole file is UNIX-only
