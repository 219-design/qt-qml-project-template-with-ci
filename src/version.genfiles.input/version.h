#ifndef PROJ_LIB_VERSION_H
#define PROJ_LIB_VERSION_H

// WARNING:
// THIS FILE IS "OWNED" BY AN AUTOMATED SCRIPT.
//
// If you would like to define utility functions that operate on these
// constants, please add them to a relevant package by adding a NEW FILE in your
// package. Same advice applies if you wish to define compound vars that
// concatenate any of these strings: do it in another file. Let's keep this file
// dirt simple to avoid any complications or errors in our scripts.
namespace project
{
constexpr char BUILD_ON_DATE[] = "yyyy-mm-dd";
constexpr char GIT_HASH_WHEN_BUILT[] = "abcdefghij";
} // namespace project

#endif // PROJ_LIB_VERSION_H
