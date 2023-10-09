set(gtest_sources
    src/gtest-all.cc
)

# Leave off SHARED/STATIC in add_library. Controlled at top-level.
add_library(
  googletest
  ${gtest_sources}
  ${gtest_headers}
)

target_include_directories(
  googletest
  PRIVATE .
          ./include
)

target_link_libraries(
  googletest
)
