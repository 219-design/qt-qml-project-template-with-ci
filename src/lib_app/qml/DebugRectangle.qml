import QtQuick 2.12
import QtQuick.Controls.Material 2.12

Rectangle {
  property var toFill: parent
  property color customColor: "yellow" // instantiation site "can" (optionally) override
  property int customThickness: 1 // instantiation site "can" (optionally) override

  // This is a bit of a "clever hack" for debugging.
  // There are a limited number of environment vars passed through to QML.
  // https://doc.qt.io/qt-5/qtquickcontrols2-environment.html
  // Here, we hijack the QT_QUICK_CONTROLS_MATERIAL_ACCENT variable as a visibility flag.
  // In this way, you can insert 'DebugRectangle' items wherever you want in your QML.
  // When you wish for the DebugRectangle(s) to become visible (in a production binary executable
  // or under qmlscene), then just do this before launch:
  // export QT_QUICK_CONTROLS_MATERIAL_ACCENT="#0B610B"
  readonly property color sentinelColor: "#0B610B"
  visible: Material.accent == sentinelColor

  anchors.fill: toFill
  z: 200
  color: "transparent"
  border.color: customColor
  border.width: customThickness
}
