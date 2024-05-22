set(lib_example_sources
    example_shared.cc
)

# Leave off SHARED/STATIC in add_library. Controlled at top-level.
add_library(
  lib_example
  ${lib_example_sources}
)

target_compile_options(
  lib_example
  PRIVATE ${MYAPP_COMPILER_WARNINGS}
)

# On Linux, use "$ORIGIN" rpath so dylibs can be in the same dir as the app
set_target_properties(
  lib_example
  PROPERTIES BUILD_RPATH_USE_ORIGIN
             TRUE
)
