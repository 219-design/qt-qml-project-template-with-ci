pragma Singleton

import QtQuick 2.12

Item {
  property int rootHeight: 400 // expected to be updated by the ApplicationWindow (main.qml)
  property int rootWidth: 200 // expected to be updated by the ApplicationWindow (main.qml)
  property bool inLandscapeLayout: false // expected to be updated by the ApplicationWindow (main.qml)

  onInLandscapeLayoutChanged: {
    console.log('inLandscapeLayout became:', inLandscapeLayout)
  }
}
