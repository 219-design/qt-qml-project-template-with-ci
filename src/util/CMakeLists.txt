set(util_sources
    am_i_inside_debugger.cc
    deleter_with_qt_deferred_deletion.cc
    every_so_often.cc
    timer_service.cc
    qml_message_interceptor.cc
)

# Note: only list headers that need MOC
set(util_headers
    timer_service.h
)

# Leave off SHARED/STATIC in add_library. Controlled at top-level.
add_library(
  util
  ${util_sources}
  ${util_headers}
)

set(MY_LIB_UTIL_WARNINGS
    ${MYAPP_COMPILER_WARNINGS}
)
if(UNIX)
  list(
    APPEND
    MY_LIB_UTIL_WARNINGS
    "-Wno-error=unknown-pragmas"
  )
endif() # if(UNIX)

target_compile_options(
  util
  PRIVATE ${MY_LIB_UTIL_WARNINGS}
)

target_link_libraries(
  util
  PRIVATE Qt::Core
)

set(util_tests_sources
    tests/timer_service_test.cc
)

if(WIN32)
  # Most of our project has seen success with MSVC: "/experimental:external"
  # "/external:W0" "/external:I"
  #
  # However, (perhaps because the feature is experimental after all), we get a
  # fatal warning-as-error from:
  #
  # MSVC\14.24.28314\include\ppltaskscheduler.h(52): warning C4355: 'this': used
  # in base member initializer list
  #
  # ... when compiling timer_service_test.cc. So we relax that warning just in
  # this one spot (for now).
  set_source_files_properties(
    tests/timer_service_test.cc
    PROPERTIES COMPILE_FLAGS
               "/wd4355 /wd5204"
  )
endif() # if(WIN32)

add_executable(
  util_tests
  ${util_tests_sources}
)

# add on 'isystem' path so they are 'immune' to compiler warnings
target_include_directories(
  util_tests
  SYSTEM
  PRIVATE
    ${CMAKE_SOURCE_DIR}/third_party/googletest-release-1.11.0/googlemock/include
    ${CMAKE_SOURCE_DIR}/third_party/googletest-release-1.11.0/googletest/include
)

target_include_directories(
  util_tests
  PRIVATE ${CMAKE_SOURCE_DIR}
)

target_compile_options(
  util_tests
  PRIVATE ${MYAPP_COMPILER_WARNINGS}
)

if(UNIX)
  # Fixing: undefined reference to symbol 'pthread_getspecific@@GLIBC_2.2.5' Due
  # to:
  #
  # gtest-port.h:1767:    DeleteThreadLocalValue(pthread_getspecific(key_));
  # gtest-port.h:1804:
  # static_cast<ThreadLocalValueHolderBase*>(pthread_getspecific(key_));
  set(PThreadLib
      -pthread
  )
endif()

target_link_libraries(
  util_tests
  PRIVATE Qt::Core
          Qt::Test
          googlemock
          googletest
          testmain
          util
          ${PThreadLib}
)
