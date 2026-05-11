import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.14
import libstyles 1.0

Rectangle {
  id: root

  // color: grid.primarySwatches[index] // set at instantiation site
  opacity: 1 // this line is here to force qmlfmt to keep the 'color' line where it is.

  property var colorSetterFunctor
  property int indexForColorSetter: 0

  readonly property color invisible_: 'transparent'

  ColorDialog {
    id: colorDialog
    title: "Please choose a color"

    property var functor

    onAccepted: {
      console.log("You chose: " + colorDialog.color)
      functor(colorDialog.color)
    }
    onRejected: {
      console.log("ColorDialog Canceled")
    }
  }

  Label {
    id: a
    anchors.centerIn: parent
    text: root.color
    color: "white"
    visible: !Qt.colorEqual(root.color, root.invisible_)
  }
  Label {
    anchors.top: a.bottom
    anchors.left: a.left
    text: root.color
    color: "black" // a second label (showing same info), in case we are on a LIGHT background
    visible: !Qt.colorEqual(root.color, root.invisible_)
  }

  MouseArea {
    anchors.fill: parent
    onClicked: {
      console.log(root.color)
    }
    onDoubleClicked: {
      colorDialog.functor = function (copyIdx) {
        return function (val) {
          colorSetterFunctor(copyIdx, val)
        }
      }(indexForColorSetter)
      console.log('Color swatch clicked', root.color)
      colorDialog.color = root.color
      colorDialog.currentColor = root.color
      colorDialog.open()
    }
  }
}
