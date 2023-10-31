set(minutil_sources
    logger.cc
    x_unistd.cc
)

# Leave off SHARED/STATIC in add_library. Controlled at top-level.
add_library(
  minutil
  ${minutil_sources}
)

target_include_directories(
  minutil
  PRIVATE ${CMAKE_SOURCE_DIR}
)

target_compile_options(
  minutil
  PRIVATE ${MYAPP_COMPILER_WARNINGS}
)

# On Linux, use "$ORIGIN" rpath so dylibs can be in the same dir as the app
set_target_properties(
  minutil
  PROPERTIES BUILD_RPATH_USE_ORIGIN
             TRUE
)
