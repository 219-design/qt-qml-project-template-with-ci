set(libstyles_sources
    resources.cc
    resource_helper.cc
)

# Note: only list headers that need MOC
set(libstyles_headers
    resource_helper.h
)

qt_add_resources(
  RC_SRC
  imports/libstyles/libstyles.qrc
)

add_library(
  libstyles
  SHARED
  ${libstyles_sources}
  ${libstyles_headers}
  ${RC_SRC}
)

target_include_directories(
  libstyles
  PRIVATE ${PROJECT_SOURCE_DIR}
          imports
          imports/libstyles
)

target_link_libraries(
  libstyles
  PRIVATE Qt::Core
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

# On Linux, use "$ORIGIN" rpath so dylibs can be in the same dir as the app
set_target_properties(
  libstyles
  PROPERTIES BUILD_RPATH_USE_ORIGIN
             TRUE
             OUTPUT_NAME
             "libstylesplugin" # to match old qmake DLL name for our sh scripts
)
