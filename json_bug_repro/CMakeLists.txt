cmake_minimum_required(VERSION 3.16)

project(Reproducejsonbug VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Bluetooth)

qt_standard_project_setup(REQUIRES 6.5)


qt_add_executable(appReproducejsonbug
    main.cpp
)

qt_add_qml_module(appReproducejsonbug
    URI Reproducejsonbug
    VERSION 1.0
        QML_FILES  qml/Main.qml
)

set_target_properties(appReproducejsonbug PROPERTIES
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appReproducejsonbug
    PRIVATE Qt6::Quick
)
