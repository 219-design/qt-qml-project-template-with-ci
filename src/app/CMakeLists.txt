set(app_sources
    event_filter.cc
    gui_tests.cc
    main.cc
    view_model_collection.cc
)

# Note: only list headers that need MOC
set(app_headers
    event_filter.h
    gui_tests.h
)

add_executable(
  app
  ${app_sources}
  ${app_headers}
)

target_include_directories(
  app
  PRIVATE ${PROJECT_SOURCE_DIR}
          ${PROJECT_BINARY_DIR}/generated_files # for version.h
)

target_compile_options(
  app
  PRIVATE ${MYAPP_COMPILER_WARNINGS}
)

target_link_libraries(
  app
  PRIVATE Qt::Core
          Qt::Qml
          Qt::Quick
          Qt::QuickControls2 # when we use: QQuickStyle::setStyle( "Fusion" );
          Qt::Widgets
          lib_app
          libstyles
          minutil
          util
)

# On Linux, use "$ORIGIN" rpath so dylibs can be in the same dir as the app
set_target_properties(
  app
  PROPERTIES BUILD_RPATH_USE_ORIGIN
             TRUE
)
