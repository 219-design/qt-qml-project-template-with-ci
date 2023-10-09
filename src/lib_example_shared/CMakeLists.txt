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
