find_package(
  Qt5QuickCompiler
) # TODO (move to top-level?)
qtquick_compiler_add_resources(
  RESOURCES
  libresources.qrc
) # TODO: we probably also need qt_add_resources like in libstyles?

set(lib_app_sources
    cli_options.cc
    lib.cc
    logging_tags.cc
    resources.cc
)

set(lib_app_headers
    lib.h
    logging_tags.h
)

# Leave off SHARED/STATIC in add_library. Controlled at top-level.
add_library(
  lib_app
  ${lib_app_sources}
  ${lib_app_headers}
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

target_compile_options(
  lib_app
  PRIVATE ${MYAPP_COMPILER_WARNINGS}
)

# add_executable(lib_tests ${lib_test_sources})

# target_link_libraries( lib_tests Qt::Core Qt::Test Qt::Widgets Qt::Qml
# Qt::Quick libstyles util googletest googlemock testmain)
# target_compile_options(lib_tests PRIVATE ${MYAPP_COMPILER_WARNINGS})
