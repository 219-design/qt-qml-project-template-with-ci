cmake_minimum_required(
  VERSION 3.24
)

cmake_policy(
  VERSION
  3.24
)

if(NOT
   DEFINED
   ENV{Qt5_DIR}
)
  message(
    FATAL_ERROR
      "You must set Qt5_DIR. This project was intended to be very\
 strict about requiring your explicit path to your chosen Qt toolchain.\
 (remove this check from the project if/when no longer relevant)"
  )
endif()

if(NOT
   DEFINED
   ENV{Qt6_DIR}
)
  message(
    FATAL_ERROR
      "You must set Qt6_DIR. This project was intended to be very\
 strict about requiring your explicit path to your chosen Qt toolchain.\
 (remove this check from the project if/when no longer relevant)"
  )
endif()

project(
  gui_app
)

set(CMAKE_CXX_STANDARD
    17
)

find_package(
  Qt5
  CONFIG
  REQUIRED
  COMPONENTS Core
             Qml
             Quick
             QuickControls2
             Test
             Widgets
)

set(CMAKE_AUTOMOC
    ON
)
set(CMAKE_AUTORCC
    ON
)
set(CMAKE_AUTOUIC
    ON
)

# ##############################################################################
# Begin section: based on the book "Professional CMake" by Craig Scott
#
# ISBN 978-1-925904-24-6, 15th edition. 2023.
# https://crascit.com/professional-cmake/
#
# 34.5.2. Target Output Locations
#
# When all targets should use the same consistent output locations, these
# variables can be set at the top of the project so that the properties don't
# have to be set for every target individually. To allow the project to be
# incorporated into a larger project hierarchy, these variables should only be
# set if they are not already set so that parent projects can override the
# output locations. They should also use a location relative to
# CMAKE_CURRENT_BINARY_DIR rather than CMAKE_BINARY_DIR.

# include( GNUInstallDirs ) # <--- uncomment to distinguish 'bin/' from 'lib/'

set(stageDir
    ${CMAKE_CURRENT_BINARY_DIR}/stage
)

if(NOT
   CMAKE_RUNTIME_OUTPUT_DIRECTORY
)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY
      ${stageDir}/${CMAKE_INSTALL_BINDIR}
  )
endif()

if(NOT
   CMAKE_LIBRARY_OUTPUT_DIRECTORY
)
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY
      ${stageDir}/${CMAKE_INSTALL_LIBDIR}
  )
endif()

if(NOT
   CMAKE_ARCHIVE_OUTPUT_DIRECTORY
)
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY
      ${stageDir}/${CMAKE_INSTALL_LIBDIR}
  )
endif()

# End section: based on the book "Professional CMake" by Craig Scott
# ##############################################################################

include(
  cmake_include/cross_platform_settings.cmake
)

add_subdirectory(
  src/app
)
add_subdirectory(
  src/lib_app
)
add_subdirectory(
  src/lib_example_shared
)
add_subdirectory(
  src/libstyles
)
add_subdirectory(
  src/libtests
)
add_subdirectory(
  src/minutil
)
add_subdirectory(
  src/util
)
add_subdirectory(
  third_party/googletest-release-1.11.0/googlemock
)
add_subdirectory(
  third_party/googletest-release-1.11.0/googletest
)
