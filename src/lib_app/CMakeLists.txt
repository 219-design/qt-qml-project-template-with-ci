qt_add_resources(
  RC_SRC
  libresources.qrc
)

set(lib_app_sources
    cli_options.cc
    lib.cc
    logging_tags.cc
    resources.cc
)

if(IOS)
  set(lib_app_sources
      ${lib_app_sources}
      ios/ios_log_redirect.mm
  )
else()
  set(lib_app_sources
      ${lib_app_sources}
      ios/ios_log_redirect.cc
  )
endif() # if (IOS)

if(ANDROID)
  set(lib_app_sources
      ${lib_app_sources}
      android/intent_to_email.cc
  )
endif() # if (ANDROID)

# Note: only list headers that need MOC
set(lib_app_headers
    lib.h
    logging_tags.h
)

# Leave off SHARED/STATIC in add_library. Controlled at top-level.
add_library(
  lib_app
  ${lib_app_sources}
  ${lib_app_headers}
  ${RC_SRC}
)

target_include_directories(
  lib_app
  PRIVATE ${PROJECT_SOURCE_DIR}
)

target_link_libraries(
  lib_app
  PRIVATE Qt::Core
          Qt::Widgets
          Qt::Qml
          Qt::Quick
          libstyles
          lib_example
          util
)

if(ANDROID)
  target_link_libraries(
    lib_app
    PRIVATE Qt::CorePrivate
  )
endif() # if (ANDROID)

target_compile_options(
  lib_app
  PRIVATE ${MYAPP_COMPILER_WARNINGS}
)

# On Linux, use "$ORIGIN" rpath so dylibs can be in the same dir as the app
set_target_properties(
  lib_app
  PROPERTIES BUILD_RPATH_USE_ORIGIN
             TRUE
)

set(lib_tests_sources
    navigation_test.cc
)

add_executable(
  lib_tests
  ${lib_tests_sources}
)

# add on 'isystem' path so they are 'immune' to compiler warnings
target_include_directories(
  lib_tests
  SYSTEM
  PRIVATE
    ${PROJECT_SOURCE_DIR}/third_party/googletest-release-1.11.0/googlemock/include
    ${PROJECT_SOURCE_DIR}/third_party/googletest-release-1.11.0/googletest/include
)

target_include_directories(
  lib_tests
  PRIVATE ${PROJECT_SOURCE_DIR}
)

target_compile_options(
  lib_tests
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
  lib_tests
  PRIVATE Qt::Core
          Qt::Test
          googlemock
          googletest
          testmain
          util
          ${PThreadLib}
)

# On Linux, use "$ORIGIN" rpath so dylibs can be in the same dir as the app
set_target_properties(
  lib_tests
  PROPERTIES BUILD_RPATH_USE_ORIGIN
             TRUE
)
