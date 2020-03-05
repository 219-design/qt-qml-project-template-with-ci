import QtQuick 2.12
import QtQuick.Controls 2.12


// (apparently because constantly resizing an SVG would be expensive in an app
// that allows a user to resize the screen at any time...) QML has made an
// "interesting" (at times annoying) choice to first render an SVG to
// essentially create a PNG from it, and then AFTER THAT only this PNG is scaled,
// which means IT WILL SCALE INTO A PIXELATED JAGGED MESS, which is the opposite
// of what you expect from an SVG!
// https://forum.qt.io/topic/52161/properly-scaling-svg-images/5
Image {
  // Thanks to this hack, qml can now only DOWN-SCALE/SHRINK the SVG, which won't cause blurriness/pixelation
  sourceSize: Qt.size(
                // first "trick" qml that the SVG is larger than we EVER NEED
                Math.max(hiddenImg.sourceSize.width, 250),
                Math.max(hiddenImg.sourceSize.height, 250))

  Image {
    id: hiddenImg
    source: parent.source
    width: 0
    height: 0
  }
}
