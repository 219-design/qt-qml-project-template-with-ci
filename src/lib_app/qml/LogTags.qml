import QtQuick 2.12
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
// -----------------------------------------------------------------------------
// Rationale for Singleton LoggingCategory(s) comes from qt docs:
// https://web.archive.org/web/20181016025119/https://doc.qt.io/qt-5/qml-qtqml-loggingcategory.html
// "Note: As the creation of objects is expensive, it is encouraged to put the
// needed LoggingCategory definitions into a singleton and import this where
// needed."
pragma Singleton

Item {
  property alias guiTests: gui

  LoggingCategory {
    id: gui

    name: customLoggingCategories.guiTestingLogTag
    defaultLogLevel: LoggingCategory.Info
  }
}
