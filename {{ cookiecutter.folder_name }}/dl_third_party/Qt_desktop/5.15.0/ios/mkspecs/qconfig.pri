host_build {
    QT_ARCH = x86_64
    QT_BUILDABI = x86_64-little_endian-lp64
    QT_TARGET_ARCH = arm64
    QT_TARGET_BUILDABI = arm64-little_endian-lp64
} else {
    QT_ARCH = arm64
    QT_BUILDABI = arm64-little_endian-lp64
}
QT.global.enabled_features = cross_compile appstore-compliant debug_and_release build_all c++11 c++14 c++17 c++1z c99 c11 thread future concurrent signaling_nan simulator_and_device static
QT.global.disabled_features = shared shared framework rpath c++2a pkg-config force_asserts separate_debug_info
CONFIG += cross_compile debug static
QT_CONFIG += debug_and_release release debug build_all c++11 c++14 c++17 c++1z concurrent no-pkg-config reduce_exports release_tools simulator_and_device static stl
QT_VERSION = 5.15.0
QT_MAJOR_VERSION = 5
QT_MINOR_VERSION = 15
QT_PATCH_VERSION = 0
QT_GCC_MAJOR_VERSION = 4
QT_GCC_MINOR_VERSION = 2
QT_GCC_PATCH_VERSION = 1
QT_MAC_SDK_VERSION = 13.2
QT_APPLE_CLANG_MAJOR_VERSION = 11
QT_APPLE_CLANG_MINOR_VERSION = 0
QT_APPLE_CLANG_PATCH_VERSION = 0
QT_EDITION = OpenSource
QT_LICHECK = 
QT_RELEASE_DATE = 2020-04-04
