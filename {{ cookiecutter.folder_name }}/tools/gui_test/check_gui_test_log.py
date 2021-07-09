#!/usr/bin/python3

#
# Copyright (c) 2020, 219 Design, LLC
# See LICENSE.txt
#
# https://www.219design.com
# Software | Electrical | Mechanical | Product Design
#

import sys

MUST_HAVE = [
    "ApplicationWindow onCompleted",
]

MUST_NOT = [
    "Apparently out-of-range date",
    "called when not loading",
    "can't resolve property alias for 'on' assignment",
    "Cannot create a component",
    "Cannot create new component instance",
    "Cannot pause a stopped animation",
    "Cannot set context object",
    "Cannot set property",
    "Component creation is recursing",
    "Component destroyed while completion pending",
    "Component is not ready",
    "Could not convert argument",
    "Could not convert array value",
    "Cyclic dependency detected ",
    "cyclic prototype value",
    "Detected anchors on an item that is managed by a layout",
    "emitted, but no receivers connected to handle it",
    "Failed to get image from provider",
    "failed to load component",
    "insertAnimation only supports to add animations after the current one",
    "Model size of",  # "...is less than 0" AND/OR "...is bigger than upper limit"
    "Must provide an engine",
    "QML LoaderImage",
    "qmlRegisterSingletonType requires absolute URLs",
    "qmlRegisterType requires absolute URLs",
    "ReferenceError:",
    "specifying the encoding as fourth argument is deprecated",
    "TypeError",
    "Unable to assign",
    "Unable to handle unregistered datatype",
    "unregistered datatype",
]


def assert_file_line(line, targets):
    for sought_after_key in targets.keys():
        if sought_after_key in line:
            targets[sought_after_key] += 1
            # Note that if a line matches a GOOD string, we don't check that
            # line against the BAD strings.  This means a GOOD match 'wins'. So
            # if a you need to include a line which has a BAD string as part of
            # it, just make a LONGER 'superset line' in MUST_HAVE so that it
            # matches first and 'wins'
            return

    for bad_line in MUST_NOT:
        if bad_line in line:
            raise Exception("Found unwanted output: %s" % (bad_line))


def main():
    if (len(sys.argv)) >= 4:
        # 'argv[2]' will be used as additional MUST_HAVE(s)
        with open(sys.argv[2]) as fp:
            line = fp.readline()
            while line:
                MUST_HAVE.append(line.rstrip())
                line = fp.readline()
        # 'argv[3]' will be used as additional MUST_NOT(s)
        with open(sys.argv[3]) as fp:
            line = fp.readline()
            while line:
                MUST_NOT.append(line.rstrip())
                line = fp.readline()

    targets_map = {}
    for s in MUST_HAVE:
        targets_map[s] = 0

    with open(sys.argv[1]) as fp:
        line = fp.readline()
        while line:
            assert_file_line(line, targets_map)
            line = fp.readline()

    count = 0
    for k, v in targets_map.items():
        count += 1
        if v < 1:
            raise Exception("Failed to find a MUST_HAVE string: %s" % (k))

    print("Found all %d MUST_HAVE strings." % (count))


if __name__ == '__main__':
    main()
