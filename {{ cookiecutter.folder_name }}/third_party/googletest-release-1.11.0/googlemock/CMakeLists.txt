set(gmock_sources
    src/gmock-all.cc
)

# Leave off SHARED/STATIC in add_library. Controlled at top-level.
add_library(
  googlemock
  ${gmock_sources}
)

target_include_directories(
  googlemock
  PRIVATE .
          ./include
          ../googletest/include
)

target_link_libraries(
  googlemock
  PRIVATE googletest
)
