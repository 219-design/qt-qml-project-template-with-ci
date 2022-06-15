// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
import QtGraphicalEffects 1.12
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Universal 2.2
import libstyles 1.0

ApplicationWindow {
  id: root

  title: "Hello World"

  // Perform palette overrides at root ApplicationWindow to affect whole app:
  // palette.window: '#777777' // <-- when using QQuickStyle::setStyle, you can override palette
  width: 400
  height: 720
  visible: true

  function updateGlobals() {
    Globals.rootHeight = root.height
    Globals.rootWidth = root.width
    Globals.inLandscapeLayout = root.width > root.height
  }
  onHeightChanged: {
    root.updateGlobals()
  }
  onWidthChanged: {
    root.updateGlobals()
  }

  Component.onCompleted: {
    root.updateGlobals()
    // Don't mess with 'guiTests' log statements, or you risk breaking a test.
    console.log(LogTags.guiTests, "ApplicationWindow onCompleted")
  }

  Rectangle {
    id: main

    color: Theme.neutralLight
    anchors.fill: parent

    Pane {
      id: logo

      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      height: Utils.percentOfAppHeightCappedMinAndMax(0.25, 140, 500)
      width: height
      focusPolicy: Qt.StrongFocus
      Keys.onSpacePressed: {
        logoImage.rotation = logoImage.rotation + 90
      }

      background: ImageSvgHelper {
        id: logoImage

        source: blacknwhite.checked ? resourceHelper.imageSourcePrefix
                                      + "images/blacknwhite.png" : resourceHelper.imageSourcePrefix
                                      + "images/219Design.png"
        fillMode: Image.PreserveAspectFit
      }
    }

    Rectangle {
      anchors.fill: logo
      color: "transparent"
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
      Keys.onSpacePressed: {
        smileyImage.rotation = smileyImage.rotation + 90
        console.log(libraryClass.getValue())
      }

      background: ImageSvgHelper {
        id: smileyImage

        source: resourceHelper.imageSourcePrefix + "images/smile.svg"
        fillMode: Image.PreserveAspectFit
      }
    }

    Rectangle {
      anchors.fill: smiley
      color: "transparent"
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

        text: "Black & White"
      }

      Button {
        id: reset

        text: "Reset"
        onClicked: {
          blacknwhite.checked = false
          logoImage.rotation = 0
          smileyImage.rotation = 0
        }

        background: Rectangle {
          color: Theme.successColor
          border.width: reset.activeFocus ? 2 : 0
          border.color: Universal.accent
        }
      }
    }

    Column {
      id: directionsCol

      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: row.bottom
      topPadding: 40
      spacing: 10

      Label {
        text: "Keyboard Controls:"
        font.bold: true
        color: Theme.accentOtherDark
      }

      Label {
        text: "TAB: iterates focus over each item"
      }

      Label {
        text: "SPACEBAR (on checkbox): toggles checkbox"
      }

      Label {
        text: "SPACEBAR (on button): presses button"
      }

      Label {
        text: "SPACEBAR (on logo): rotates logo"

        DebugRectangle {// To make the DebugRectangle show up in the GUI, change your environment:
          //     export QT_QUICK_CONTROLS_MATERIAL_ACCENT="#0B610B"
          // (See comments in DebugRectangle.qml for more information.)
        }
      }

      Item {
        width: 1
        height: 10
      }

      Label {
        text: "Font Awesome Demo:"
        font.bold: true
        color: Theme.accentOtherDark
      }
    }

    Row {
      anchors.top: directionsCol.bottom
      anchors.topMargin: 5
      anchors.horizontalCenter: parent.horizontalCenter
      width: directionsCol.width

      Label {
        text: Fonts.fa_regular_gem // refer to Cheatsheet_Font_Awesome_Regular.pdf
        font: Theme.regIconFont
        color: Theme.successColor
      }

      Label {
        height: 130
        text: Fonts.fa_solid_dna // refer to Cheatsheet_Font_Awesome_Solid.pdf
        font: Theme.solidIconStretchToMaxFitFont
        fontSizeMode: Text.Fit
        color: Theme.accentDark

        MouseArea {
          anchors.fill: parent
          onClicked: {
            customLoggingCategories.handleMobileLink("email test on android")
          }
        }
      }
    }

    Rectangle {
      anchors.bottom: parent.bottom
      anchors.bottomMargin: 20
      anchors.horizontalCenter: parent.horizontalCenter
      color: Utils.colorWithAlpha(Theme.secondaryDark, 0.3)
      height: version.contentHeight
      width: version.contentWidth

      VersionLabel {
        id: version
        anchors.fill: parent
      }
    }
  }

  Desaturate {
    // turns the whole GUI application to black and white, for evaluating certain design choices.
    visible: false // flip to true when/if you find it helpful in UI design.
    enabled: visible

    anchors.fill: main
    source: main
    desaturation: 1 // 0 to 1. 1 is 100% desaturated, which means grayscale
  }
}
