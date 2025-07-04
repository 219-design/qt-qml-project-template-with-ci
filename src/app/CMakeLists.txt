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

if(QT_DEFAULT_MAJOR_VERSION
   EQUAL
   5
)
  add_executable(
    app
    ${app_sources}
    ${app_headers}
  )
else()
  qt_add_executable(
    app
    ${app_sources}
    ${app_headers}
  )
endif()

target_include_directories(
  app
  PRIVATE ${PROJECT_SOURCE_DIR}
          ${PROJECT_BINARY_DIR}/generated_files # for version.h
)

if(ANDROID)
  # Android multiarch (multiple architecture, arm+x86, etc) creates a lot of
  # subfolders and runs various compilation tasks from various subpaths, so we
  # need to give it lots of help to be sure that our autogenerated version.h
  # header is found:
  target_include_directories(
    app
    PRIVATE ${PROJECT_SOURCE_DIR}
            ${PROJECT_BINARY_DIR}/../generated_files/
            ${PROJECT_BINARY_DIR}/../../../generated_files/
  )
endif() # if (ANDROID)

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
             QT_ANDROID_PACKAGE_SOURCE_DIR
             ${CMAKE_SOURCE_DIR}/src/lib_app/android
             QT_ANDROID_ABIS
             "armeabi-v7a;arm64-v8a;x86;x86_64"
             QT_ANDROID_BUILD_ALL_ABIS
             ON
             QT_ANDROID_TARGET_SDK_VERSION
             33
)
