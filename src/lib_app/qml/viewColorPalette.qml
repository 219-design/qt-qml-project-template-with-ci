// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.14
import libstyles 1.0

ApplicationWindow {
  id: root
  title: "Color Palette"
  height: 700
  width: 600

  visible: true
  color: "#CCCCCC"

  GridLayout {
    id: grid
    columns: 5
    anchors.top: parent.top
    width: (swatchHeight_ + 10) * columns
    height: parent.height * .7

    readonly property int swatchHeight_: 80

    // qmlfmt formats this map in a weird way, but the code is fine
    property var primarySwatches: {
      "0": Theme.primaryDark,
      "1": Theme.primaryMediumDark,
      "2": Theme.primaryMedium,
      "3": Theme.primaryMediumLight,
      "4": Theme.primaryLight
    }

    Repeater {
      model: 5

      ColorPaletteSwatch {
        id: s1
        height: grid.swatchHeight_
        width: height
        color: grid.primarySwatches[index]

        colorSetterFunctor: Theme.setPrimary
        indexForColorSetter: index
      }
    }

    // qmlfmt formats this map in a weird way, but the code is fine
    property var secondarySwatches: {
      "0": Theme.secondaryDark,
      "1": Theme.secondaryMediumDark,
      "2": Theme.secondaryMedium,
      "3": Theme.secondaryMediumLight,
      "4": Theme.secondaryLight
    }

    Repeater {
      model: 5

      ColorPaletteSwatch {
        id: s2
        height: grid.swatchHeight_
        width: height
        color: grid.secondarySwatches[index]

        colorSetterFunctor: Theme.setSecondary
        indexForColorSetter: index
      }
    }

    // qmlfmt formats this map in a weird way, but the code is fine
    property var neutralSwatches: {
      "0": Theme.neutralDark,
      "1": Theme.neutralMediumDark,
      "2": Theme.neutralMedium,
      "3": Theme.neutralMediumLight,
      "4": Theme.neutralLight
    }

    Repeater {
      model: 5

      ColorPaletteSwatch {
        id: s3
        height: grid.swatchHeight_
        width: height
        color: grid.neutralSwatches[index]

        colorSetterFunctor: Theme.setNeutral
        indexForColorSetter: index
      }
    }

    // qmlfmt formats this map in a weird way, but the code is fine
    property var accentSwatches: {
      "0": Theme.accentDark,
      "1": Theme.accentMediumDark,
      "2": Theme.accentMedium,
      "3": Theme.accentMediumLight,
      "4": Theme.accentLight
    }

    Repeater {
      model: 5

      ColorPaletteSwatch {
        id: s4
        height: grid.swatchHeight_
        width: height
        color: grid.accentSwatches[index]

        colorSetterFunctor: Theme.setAccent
        indexForColorSetter: index
      }
    }

    // qmlfmt formats this map in a weird way, but the code is fine
    property var accentOtherSwatches: {
      "0": Theme.accentOtherDark,
      "1": Theme.accentOtherMediumDark,
      "2": Theme.accentOtherMedium,
      "3": Theme.accentOtherMediumLight,
      "4": Theme.accentOtherLight
    }

    Repeater {
      model: 5

      ColorPaletteSwatch {
        id: s5
        height: grid.swatchHeight_
        width: height
        color: grid.accentOtherSwatches[index]

        colorSetterFunctor: Theme.setAccentOther
        indexForColorSetter: index
      }
    }
  }

  RowLayout {
    anchors.top: grid.bottom
    anchors.topMargin: 130
    height: parent.height - grid.height - 130
    width: parent.width
    spacing: 10

    ColorPaletteSwatch {
      Layout.fillWidth: true
      Layout.fillHeight: true
      color: Theme.genericButtonFill
      radius: 10
      Text {
        text: "button"
      }
      colorSetterFunctor: function (ignored, color) {
        Theme.genericButtonFill = color
      }
    }
    ColorPaletteSwatch {
      Layout.fillWidth: true
      Layout.fillHeight: true
      color: Theme.primaryButtonFill
      radius: 10
      Text {
        text: "hi-button" // the 'recommended' button if there are 2+
      }
      colorSetterFunctor: function (ignored, color) {
        Theme.primaryButtonFill = color
      }
    }

    Rectangle {
      id: spacer
      Layout.minimumWidth: 10
      Layout.fillHeight: true
      color: 'transparent'
    }

    Rectangle {
      Layout.fillWidth: true
      Layout.fillHeight: true
      color: 'transparent'
      radius: 10
      Text {
        text: ""
      }
    }
    ColorPaletteSwatch {
      Layout.fillWidth: true
      Layout.fillHeight: true
      color: Theme.successColor
      radius: 10
      Text {
        text: "success"
      }
      colorSetterFunctor: function (ignored, color) {
        Theme.successColor = color
      }
    }
    ColorPaletteSwatch {
      Layout.fillWidth: true
      Layout.fillHeight: true
      color: Theme.warningColor
      radius: 10
      Text {
        text: "warn"
      }
      colorSetterFunctor: function (ignored, color) {
        Theme.warningColor = color
      }
    }
    ColorPaletteSwatch {
      Layout.fillWidth: true
      Layout.fillHeight: true
      color: Theme.dangerColor
      radius: 10
      Text {
        text: "danger"
      }
      colorSetterFunctor: function (ignored, color) {
        Theme.dangerColor = color
      }
    }
  }
}
