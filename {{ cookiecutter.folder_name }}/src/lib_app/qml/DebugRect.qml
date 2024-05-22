import QtQuick 2.12
import QtQuick.Controls.Material 2.12

Item {
  id: root

  // Instantiation site must override color. (See fixed palette choices below.)
  property color color

  property var toFill: parent // instantiation site "can" (optionally) override
  property int customThickness: 1 // instantiation site "can" (optionally) override

  // This is a bit of a "clever hack" for debugging.
  // There are a limited number of environment vars passed through to QML.
  // https://doc.qt.io/qt-5/qtquickcontrols2-environment.html
  // Here, we hijack the QT_QUICK_CONTROLS_MATERIAL_ACCENT variable as a visibility flag.
  // In this way, you can insert 'DebugRect' items wherever you want in your QML.
  // When you wish for the DebugRect(s) to become visible (in a production
  // binary executable or under qmlscene), then just do this before launch:
  //    export QT_QUICK_CONTROLS_MATERIAL_ACCENT="#0B610B"
  readonly property color sentinelColor: "#0B610B"
  visible: {
    // If the environment variable configured the ACCENT color to match our sentinel,
    // then every instance of DebugRect will become visible:
    Material.accent == sentinelColor
  }

  // Limiting ourselves to this palette helps us unambiguously grep for color names
  // throughout the code, so we can easily identify which QML element we care about
  // once we have seen it highlighted in a given color when we launch the app when
  // the sentinel/ACCENT variable is active.
  // Inside of setOfColors, we can edit our definition to make any color lighter
  // or darker as needed (if, for example, the UI design suddenly calls for more purple and
  // we want to make our highlight purple lighter to get contrast). The words
  // that are "fixed forever" are the ones below (lines 38-47)
  readonly property var setOfColors: ['darkred', 'orangered', 'goldenrod', 'yellow', 'forestgreen', 'blue', 'aqua', 'purple', 'olive', 'teal']

  readonly property color red: root.setOfColors[0]
  readonly property color orange: root.setOfColors[1]
  readonly property color gold: root.setOfColors[2]
  readonly property color yellow: root.setOfColors[3]
  readonly property color green: root.setOfColors[4]
  readonly property color blue: root.setOfColors[5]
  readonly property color aqua: root.setOfColors[6]
  readonly property color purple: root.setOfColors[7]
  readonly property color olive: root.setOfColors[8]
  readonly property color teal: root.setOfColors[9]

  Component.onCompleted: {
    var warningText = 'Please always explicitly choose a standard color for each DebugRect.'
    var infoText = 'By explicitly choosing a standard color, you provide a way for developers to grep the codebase to find elements according to their debug highlight color.'
    if (!root.color) {
      console.warn(warningText)
      console.info(infoText)
      return
    }

    var matched = false
    for (var ci = 0; ci < root.setOfColors.length; ci++) {
      if (Qt.colorEqual(root.color, root.setOfColors[ci])) {
        matched = true
        break
      }
    }
    if (!matched) {
      console.warn(warningText)
      console.info(infoText)
    }
  }

  anchors.fill: toFill
  z: 200
  Rectangle {
    anchors.fill: parent
    z: 200
    color: "transparent"
    border.color: root.color
    border.width: customThickness
  }
}
