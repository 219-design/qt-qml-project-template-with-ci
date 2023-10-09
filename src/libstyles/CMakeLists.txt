set(libstyles_sources
    resources.cc
    resource_helper.cc
)

set(libstyles_headers
    resource_helper.h
)

find_package(
  Qt5QuickCompiler
) # TODO (move to top-level?)
qtquick_compiler_add_resources(
  RESOURCES
  imports/libstyles/libstyles.qrc
)

qt_add_resources(
  RC_SRC
  imports/libstyles/libstyles.qrc
)

add_library(
  libstyles
  MODULE
  ${libstyles_sources}
  ${libstyles_headers}
  ${RC_SRC}
)

target_include_directories(
  libstyles
  PRIVATE ${CMAKE_SOURCE_DIR}
          imports
          imports/libstyles
)

target_link_libraries(
  libstyles
  Qt::Core
  Qt::Qml
)

target_compile_options(
  libstyles
  PRIVATE ${MYAPP_COMPILER_WARNINGS}
)

target_compile_definitions(
  libstyles
  PRIVATE LIBSTYLES_LIBRARY
)
