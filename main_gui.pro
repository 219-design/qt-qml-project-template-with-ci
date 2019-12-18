#
# Copyright (c) 2020, 219 Design, LLC
# See LICENSE.txt
#
# https://www.219design.com
# Software | Electrical | Mechanical | Product Design
#

TEMPLATE = subdirs
SUBDIRS = app lib
# NOTE: using 'CONFIG += ordered' is considered a bad practice—prefer using .depends instead.
app.depends = lib
