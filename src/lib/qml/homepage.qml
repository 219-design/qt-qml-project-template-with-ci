// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import QtQuick.Controls.Universal 2.2
import libstyles 1.0

ApplicationWindow {
  id: rootx
  title: "Hello World"
  width: 400
  height: 520
  visible: true

  Component.onCompleted: {
    // Don't mess with 'guiTests' log statements, or you risk breaking a test.
    console.log(LogTags.guiTests, "ApplicationWindow onCompleted")
  }

  Rectangle {
    id: root
    color: Theme.accentOtherMedium
    anchors.fill: parent

    Pane {
      id: logo
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      height: 140
      width: height

      focusPolicy: Qt.StrongFocus

      background: ImageSvgHelper {
        id: logoImage
        source: blacknwhite.checked ? resourceHelper.imageSourcePrefix
                                      + "images/blacknwhite.png" : resourceHelper.imageSourcePrefix
                                      + "images/219Design.png"
        fillMode: Image.PreserveAspectFit
      }

      Keys.onSpacePressed: {
        logoImage.rotation = logoImage.rotation + 90
      }
    }

    Rectangle {
      anchors.fill: logo
      color: 'transparent'
      border.width: logo.activeFocus ? 2 : 0
      border.color: Universal.accent
    }

    Pane {
      id: smiley
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: logo.bottom
      height: 140
      width: height

      focusPolicy: Qt.StrongFocus

      background: ImageSvgHelper {
        id: smileyImage
        source: resourceHelper.imageSourcePrefix + "images/smile.svg"
        fillMode: Image.PreserveAspectFit
      }

      Keys.onSpacePressed: {
        smileyImage.rotation = smileyImage.rotation + 90
      }
    }

    Rectangle {
      anchors.fill: smiley
      color: 'transparent'
      border.width: smiley.activeFocus ? 2 : 0
      border.color: Universal.accent
    }

    Row {
      id: row
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: smiley.bottom
      spacing: 40

      CheckBox {
        id: blacknwhite
        text: 'Black & White'
      }

      Button {
        id: reset
        text: 'Reset'

        background: Rectangle {
          color: Theme.primaryButtonFill
          border.width: reset.activeFocus ? 2 : 0
          border.color: Universal.accent
        }

        onClicked: {
          blacknwhite.checked = false
          logoImage.rotation = 0
          smileyImage.rotation = 0
        }
      }
    }

    Column {
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: row.bottom
      topPadding: 40
      spacing: 10

      Label {
        text: 'Keyboard Controls:'
        font.bold: true
        color: Theme.primaryDark
      }
      Label {
        text: 'TAB: iterates focus over each item'
      }
      Label {
        text: 'SPACEBAR (on checkbox): toggles checkbox'
      }
      Label {
        text: 'SPACEBAR (on button): presses button'
      }
      Label {
        text: 'SPACEBAR (on logo): rotates logo'
      }
    }
  }
}
