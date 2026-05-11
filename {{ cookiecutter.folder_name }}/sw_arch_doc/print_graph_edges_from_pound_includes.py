#!/usr/bin/env python3
"""Copyright (c) 2025, 219 Design, LLC
See LICENSE.txt

https://www.219design.com
Software | Electrical | Mechanical | Product Design

Goal of this script: print lines of text in the graphviz 'dot' language such
that these output lines can be inserted into a larger dot file (with your own
digraph definition header) and can be used for generating an SVG visual image
representing the C/C++ header-include dependency graph of your project.

Usage notes:

   STDOUT contains the 'dot' language output. Pipe STDOUT to a file.

   STDERR contains debug/info/warning/error messages.

   Run with --help to see info about cli options.

   The notion of the filename 'stem' is of high importance in the graph
   edges. Every pair of {header/source} files is "merged" and treated as a
   single entity, using the 'stem' as the name of the entity. For example:
   "log.h" and "log.cc" become a unified entity named simply "log".  (see also:
   https://docs.python.org/3/library/pathlib.html#pathlib.PurePath.stem)

   You can put comments in your excludes_file. Comment lines with: #

   This script searches for headers included using quotes and also angle
   brackets, but the script only reports a "not found" error for headers
   included using quotes. (This is because we don't need to see hundreds of
   errors about not finding system headers anywhere on the local project include
   paths that are typically passed to the script.)
"""
import logging
import os
import argparse
import re
import sys
from pathlib import Path


logger: logging.Logger | None = None  # This is initialized in __main__

# 'mm' is Objective-C++ suffix (an Apple thing)
SRC_FILE_SUFFIXES = [
    '.c',
    '.C',
    '.cc',
    '.cpp',
    '.cxx',
    '.h',
    '.hpp',
    '.hxx',
    '.mm',
]

REGEX_POUNDINC_QUOTE = re.compile("[ \t]*#[ \t]*include[ \t]*[\"]([^\"]+)[\"]")
REGEX_POUNDINC_ANGLE = re.compile("[ \t]*#[ \t]*include[ \t]*[<]([^>]+)[>]")


class Context:
    def __init__(self, *, args: argparse.Namespace):
        self.args: argparse.Namespace = args
        self.excluded_stems: list[str] = []
        self.targets_not_found: set[str] = set()

        if self.args.excludes_file:
            if not os.path.isfile(self.args.excludes_file):
                logger.error(
                    f'The specified exclude file is not a file: {self.args.excludes_file}')
                sys.exit(1)

            for i, line in enumerate(open(self.args.excludes_file)):
                exclude = line.strip()
                if exclude.startswith('#') or len(exclude) == 0:
                    continue
                self.excluded_stems.append(exclude)

    def append_not_found(self, inc_target_str: str) -> None:
        self.targets_not_found.add(inc_target_str)

    def log_the_targets_not_found(self) -> None:
        targets = list(self.targets_not_found)
        targets.sort()
        for t in targets:
            logger.warning(f'not found: {t}')


class HeaderSourcePairUnderAnalysis:
    def __init__(self, *,
                 context: Context,
                 canonical_name: Path,
                 simple_name: str,
                 src_path: Path):
        self.context: Context = context
        self.canonical_name: Path = canonical_name
        self.simple_name = str(simple_name)
        self.dependencies: list[str] = []

        self.name_from_src_root: str | None = None
        if self.context.args.full_paths_from:
            root_src_path = Path(self.context.args.full_paths_from)
            self.name_from_src_root = str(src_path.relative_to(root_src_path))

        # box_dir_name is used to specify a box drawn by graphviz to group
        # file_stems together that live in the same source directory
        self.box_dir_name: str | None = None
        if self.canonical_name.parents:
            self.box_dir_name = str(self.canonical_name.parents[0].stem)

    def __hash__(self):
        # We define this operation in order to put HeaderSourcePair(s) in a set.
        return hash(str(self.canonical_name))

    def __eq__(self, other):
        # We define this operation in order to put HeaderSourcePair(s) in a set.
        return str(self.canonical_name) == str(other.canonical_name)

    def parse_pound_include_entries(self, filepath: str) -> None:
        """This will be called twice for a HeaderSourcePair object.  For
        example, it will be called once for "my_class.cc" and again for
        "my_class.h"
        """
        inc_targets: list[tuple[str, bool]] = []

        for i, line in enumerate(open(filepath)):
            for expr in [(REGEX_POUNDINC_QUOTE, True), (REGEX_POUNDINC_ANGLE, False)]:
                the_regex: re.Pattern = expr[0]
                expected: bool = expr[1]
                some_match = re.search(the_regex, line)
                if some_match:
                    try:
                        # Storing filename and a boolean for whether we expect
                        # to actually find the file. (We don't really try to
                        # find system headers)
                        inc_targets.append((some_match[1], expected))
                    except IndexError as e:
                        logger.error('Error. No group 1 in regex match.')

        # Now that we found some inc_targets, we do not just 'greedily' create
        # dependency-graph edges for each target. That would typically result in
        # huge graphs with edges to any/all system header, and it would not
        # respect the intent of the script's `--src-dir` option, which is
        # intended to allow the user to narrow the graph to only those files
        # located under the specified directories. Therefore, we now check
        # whether each target is actually on one of the specified paths:
        for t in inc_targets:
            filename: str = t[0]
            expected_found: bool = t[1]
            stem_name: str = str(Path(filename).stem)
            found_it: bool = False

            # "highest affinity match" would be sibling file (side-by-side)
            prospective_path_as_sibling = os.path.join(
                str(self.canonical_name.parents[0]), filename)

            if os.path.isfile(prospective_path_as_sibling):
                self.dependencies.append(stem_name)
                found_it = True

            # Next priority is to honor "from root" if that cli option was given
            if (not found_it) and self.context.args.full_paths_from:
                prospective_path_from_root = os.path.join(
                    self.context.args.full_paths_from, filename)

                if os.path.isfile(prospective_path_from_root):
                    self.dependencies.append(stem_name)
                    found_it = True

            # Now we search for the header in any of the given src_dir(s):
            if not found_it:
                for d in self.context.args.src_dir:
                    prospective_path_from_dir = os.path.join(
                        d, filename)

                    if os.path.isfile(prospective_path_from_dir):
                        self.dependencies.append(stem_name)
                        found_it = True

            if expected_found and (not found_it):
                # we want to report 'Include file not found' at end of script
                self.context.append_not_found(filename)

    def print_subgraph_box_info(self) -> None:
        if self.simple_name in self.context.excluded_stems:
            return

        if self.context.args.no_box:
            return

        if self.box_dir_name:
            # 'cluster' HAS SPECIAL MEANING in dot language. You must ensure
            # that each subgraph name begins with 'cluster'
            print(f'subgraph "cluster_box_dir_{self.box_dir_name}" {{')
            print(f'        label="{self.box_dir_name}";')
            print(f'        "{self.simple_name}";')
            print('}')

    def print_edges(self) -> None:
        if self.simple_name in self.context.excluded_stems:
            return

        self.print_subgraph_box_info()

        print(f'"{self.simple_name}"')
        # Output in sorted order, so that the output can be stored in version
        # control and show "clean diffs" over time:
        self.dependencies.sort()
        for d in self.dependencies:
            is_excluded = d in self.context.excluded_stems
            if str(self.simple_name) != d and (not is_excluded):
                print(f'"{self.simple_name}" -> "{d}"')


def traverse(*, context: Context) -> None:
    analyzed_objects: set[HeaderSourcePairUnderAnalysis] = set()

    for src_d in context.args.src_dir:
        for path, directories, files in os.walk(src_d):
            for f in files:
                src_path: Path = Path(os.path.join(path, f))
                if src_path.suffix not in SRC_FILE_SUFFIXES:
                    # File is not C/C++, so skip it:
                    continue

                # Examples of what these strings will contain:
                #   src_path:           ../src/util/logging.h
                #   actual_full_path:   /opt/myproject/src/util/logging.h
                #   idealized_name:     /opt/myproject/src/util/logging

                idealized_name = os.path.realpath(
                    os.path.join(path, src_path.stem))
                actual_full_path = os.path.realpath(os.path.join(path, f))

                matching = filter(
                    lambda o: str(o.canonical_name) == str(idealized_name), analyzed_objects)
                matched = list(matching)

                if matched:
                    # If our set of analyzed_objects already contained this 'stem',
                    # then we use the preexisting object and have it parse the
                    # paired file. (Recall that each HeaderSourcePair will typically
                    # parse one header and one corresponding c/cc file.)
                    matched[0].parse_pound_include_entries(actual_full_path)
                else:
                    s = HeaderSourcePairUnderAnalysis(
                        context=context,
                        canonical_name=Path(idealized_name),
                        simple_name=str(src_path.stem),
                        src_path=src_path)
                    s.parse_pound_include_entries(actual_full_path)
                    analyzed_objects.add(s)

    context.log_the_targets_not_found()

    objects = list(analyzed_objects)
    # Output in sorted order, so that the output can be stored in version
    # control and show "clean diffs" over time:
    objects.sort(key=lambda o: (o.simple_name, o.canonical_name))
    for o in objects:
        o.print_edges()


def main() -> None:
    global logger

    # basicConfig should default to using stderr, but we make it explicit here:
    logging.basicConfig(
        stream=sys.stderr,
        level=logging.DEBUG,
        format="%(asctime)s [thr:%(thread)d] [%(levelname)s] [%(name)s]: %(message)s",
    )

    logger = logging.getLogger('graph_from_pound_include')

    parser = argparse.ArgumentParser(
        prog='graph_from_pound_include',
        description='Inspect pound-includes from source files, print graph edges for use with graphviz.')

    parser.add_argument(
        '-s',
        '--src-dir',
        action='extend',
        metavar='src_dir',
        nargs='+',
        help='One of more directories to recursively scan for all C/C++ content.')
    parser.add_argument(
        '-f',
        '--full-paths-from',
        metavar='full_paths_from',
        help='Intended for use in codebases with long/full includes, like #include "src/app/event_filter.h"')
    parser.add_argument(
        '-x',
        '--excludes-file',
        metavar='excludes_file',
        help='A file listing stem names. List one filename stem per line. These are excluded from the graph.')
    parser.add_argument(
        '-n',
        '--no-box',
        action='store_true',
        help="Omit dot-language code for drawing boxes around 'clusters' (files that share a directory)")

    args: argparse.Namespace = parser.parse_args()

    if not args.src_dir:
        logger.error('No source directories specified. Nothing to do.')
        sys.exit(1)

    context = Context(args=args)

    traverse(context=context)

    logger.info('Done')


if __name__ == '__main__':
    main()
