// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.14
import libstyles 1.0

Rectangle {
  height: 600
  width: 600

  color: '#CCCCCC'

  GridLayout {
    id: grid
    columns: 5
    anchors.top: parent.top
    width: (swatchHeight_ + 10) * columns
    height: parent.height * .8

    readonly property int swatchHeight_: 80

    property var primarySwatches: [Theme.primaryDark, Theme.primaryMediumDark, Theme.primaryMedium, Theme.primaryMediumLight, Theme.primaryLight]

    Repeater {
      model: grid.primarySwatches

      Rectangle {
        height: grid.swatchHeight_
        width: height
        color: grid.primarySwatches[index]
      }
    }

    property var secondarySwatches: [Theme.secondaryDark, Theme.secondaryMediumDark, Theme.secondaryMedium, Theme.secondaryMediumLight, Theme.secondaryLight]

    Repeater {
      model: grid.secondarySwatches

      Rectangle {
        height: grid.swatchHeight_
        width: height
        color: grid.secondarySwatches[index]
      }
    }

    property var neutralSwatches: [Theme.neutralDark, Theme.neutralMediumDark, Theme.neutralMedium, Theme.neutralMediumLight, Theme.neutralLight]

    Repeater {
      model: grid.neutralSwatches

      Rectangle {
        height: grid.swatchHeight_
        width: height
        color: grid.neutralSwatches[index]
      }
    }

    property var accentSwatches: [Theme.accentDark, Theme.accentMediumDark, Theme.accentMedium, Theme.accentMediumLight, Theme.accentLight]

    Repeater {
      model: grid.accentSwatches

      Rectangle {
        height: grid.swatchHeight_
        width: height
        color: grid.accentSwatches[index]
      }
    }

    property var accentOtherSwatches: [Theme.accentOtherDark, Theme.accentOtherMediumDark, Theme.accentOtherMedium, Theme.accentOtherMediumLight, Theme.accentOtherLight]

    Repeater {
      model: grid.accentOtherSwatches

      Rectangle {
        height: grid.swatchHeight_
        width: height
        color: grid.accentOtherSwatches[index]
      }
    }
  }

  RowLayout {
    anchors.top: grid.bottom
    anchors.topMargin: 30
    height: parent.height - grid.height - 30
    width: parent.width
    spacing: 10

    Rectangle {
      Layout.fillWidth: true
      Layout.fillHeight: true
      color: Theme.genericButtonFill
      radius: 10
      Text {
        text: "button"
      }
    }
    Rectangle {
      Layout.fillWidth: true
      Layout.fillHeight: true
      color: Theme.primaryButtonFill
      radius: 10
      Text {
        text: "hi-button" // the 'recommended' button if there are 2+
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
      color: Theme.helpOrInfoColor
      radius: 10
      Text {
        text: "help/info"
      }
    }
    Rectangle {
      Layout.fillWidth: true
      Layout.fillHeight: true
      color: Theme.successColor
      radius: 10
      Text {
        text: "success"
      }
    }
    Rectangle {
      Layout.fillWidth: true
      Layout.fillHeight: true
      color: Theme.warningColor
      radius: 10
      Text {
        text: "warn"
      }
    }
    Rectangle {
      Layout.fillWidth: true
      Layout.fillHeight: true
      color: Theme.dangerColor
      radius: 10
      Text {
        text: "danger"
      }
    }
  }
}
