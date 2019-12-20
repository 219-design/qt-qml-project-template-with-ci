// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
pragma Singleton

import QtQuick 2.12


// If we need to expand this or make it configurable, then refer to:
// https://stackoverflow.com/questions/44389883/dynamically-change-qml-theme-at-runtime-on-mouseclick
QtObject {
  readonly property color whiteishText: "lightgray"
  readonly property color darkishText: "purple"

  property font basicFont
  basicFont.bold: false
  basicFont.underline: false
  basicFont.pixelSize: 14
  basicFont.family: "arial"
}
