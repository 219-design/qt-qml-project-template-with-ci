import QtQuick 2.12

Rectangle {
  property var toFill: parent
  property color customColor: 'yellow' // instantiation site "can" (optionally) override
  property int customThickness: 1 // instantiation site "can" (optionally) override

  anchors.fill: toFill
  z: 200
  color: 'transparent'
  border.color: customColor
  border.width: customThickness
}
