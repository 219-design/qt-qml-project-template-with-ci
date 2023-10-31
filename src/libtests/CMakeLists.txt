set(testmain_sources
    test_main.cc
)

# Leave off SHARED/STATIC in add_library. Controlled at top-level.
add_library(
  testmain
  ${testmain_sources}
)

# add on 'isystem' path so they are 'immune' to compiler warnings
target_include_directories(
  testmain
  SYSTEM
  PRIVATE
    ${CMAKE_SOURCE_DIR}/third_party/googletest-release-1.11.0/googlemock/include
    ${CMAKE_SOURCE_DIR}/third_party/googletest-release-1.11.0/googletest/include
)

target_link_libraries(
  testmain
  PRIVATE Qt::Core
          googlemock
          googletest
) # qt needed when using qt_test_main.cc

target_compile_options(
  testmain
  PRIVATE ${MYAPP_COMPILER_WARNINGS}
)
