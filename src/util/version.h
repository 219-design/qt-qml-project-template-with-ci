#ifndef PROJ_LIB_VERSION_H
#define PROJ_LIB_VERSION_H

// WARNING:
// THIS FILE IS "OWNED" BY AN AUTOMATED SCRIPT.
//
// If you would like to define utility functions that operate on these
// constants, please add them to this package by adding a NEW FILE in this
// package. Same advice applies if you wish to define compound vars that
// concatenate any of these strings: do it in another file. Let's keep this file
// dirt simple to avoid any complications or errors in our scripts.

// You don't need to commit the changes to this file with every commit, but it
// is harmless if you go ahead and keep committing it.
//
// A possibly less-annoying (to yourself) way to deal with it is:
//      git update-index --assume-unchanged src/util/version.h
// (Then git won't ever show you the file as "dirty" and needing to be committed.)
namespace project
{
constexpr char BUILD_ON_DATE[] = "2020-04-09";
constexpr char GIT_HASH_WHEN_BUILT[] = "54ab349d19";
} // namespace project

#endif // PROJ_LIB_VERSION_H
