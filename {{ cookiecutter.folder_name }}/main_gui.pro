#
# Copyright (c) 2020, 219 Design, LLC
# See LICENSE.txt
#
# https://www.219design.com
# Software | Electrical | Mechanical | Product Design
#
!include($$top_srcdir/compiler_flags.pri) { error() } # each subproject must also include this

TEMPLATE = subdirs

SUBDIRS = \
    app \
    lib_app \
    lib_example_shared \
    lib_tests \
    libstyles \
    libtestmain \
    minutil \
    third_party/googletest-release-1.11.0/googlemock \
    third_party/googletest-release-1.11.0/googletest \
    util \
    util_tests

app.file = src/app/app.pro
lib_app.file = src/lib_app/lib.pro
lib_example_shared.file = src/lib_example_shared/lib_example_shared.pro
lib_tests.file = src/lib_app/lib_tests.pro
libstyles.file = src/libstyles/libstyles.pro
libtestmain.file = src/libtests/libtestmain.pro
minutil.file = src/minutil/minutil.pro
util.file = src/util/util.pro
util_tests.file = src/util/util_tests.pro

# third_party projects
googlemock.file = third_party/googletest-release-1.11.0/googlemock/googlemock.pro
googletest.file = third_party/googletest-release-1.11.0/googletest/googletest.pro

# The 'app' does not directly depend on this entire set of libraries.
# Instead, think of this massive dependency list as a way for us to tell qmake
# that "the install directory of app" indeed depends on (aka 'wishes to
# contain') all these libraries.
app.depends = \
    lib_app \
    lib_example_shared \
    lib_tests \
    libstyles \
    libtestmain \
    minutil \
    third_party/googletest-release-1.11.0/googlemock \
    third_party/googletest-release-1.11.0/googletest \
    util \
    util_tests

# The remaining 'depends' lines are used in the 'traditional' sense of actually
# specifying the miminum link-time dependencies of each item:

# NOTE: using 'CONFIG += ordered' is considered a bad practice—prefer using .depends instead.
googlemock.depends = third_party/googletest-release-1.11.0/googletest
lib_app.depends = libstyles util lib_example_shared
lib_tests.depends = lib_app libtestmain third_party/googletest-release-1.11.0/googletest third_party/googletest-release-1.11.0/googlemock
libtestmain.depends = third_party/googletest-release-1.11.0/googletest third_party/googletest-release-1.11.0/googlemock
util_tests.depends = util libtestmain
