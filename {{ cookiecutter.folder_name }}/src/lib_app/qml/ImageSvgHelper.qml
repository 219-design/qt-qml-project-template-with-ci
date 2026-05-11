import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
  id: root

  // We cannot use 'alias', since these must be available to the Image AND the AnimatedImage
  property var fillMode: nil
  property url source: ""

  Image {
    id: nonGif

    visible: !(source + "").endsWith("gif")
    anchors.fill: parent
    source: root.source
    fillMode: {
      if (!!root.fillMode)
        root.fillMode
      else
        Image.Stretch
    }

    // Without telling Qt to consider that the sourceSize is as follows, we
    // would at times fall into the trap where an SVG contains TINY values
    // in the SVG code for 'width/height/viewBox', and Qt will take those to be
    // the definitive size of the image, which will lead to a horribly pixelated
    // outcome such as that shown: https://github.com/219-design/qt-qml-project-template-with-ci/pull/6
    // (See also: https://forum.qt.io/topic/52161/properly-scaling-svg-images/5)
    sourceSize: Qt.size(nonGif.width, nonGif.height)

    Image {
      id: hiddenImg

      source: parent.source
      width: 0
      height: 0
    }
  }

  AnimatedImage {
    id: gif

    visible: !nonGif.visible
    source: root.source
    anchors.fill: parent
    fillMode: {
      if (!!root.fillMode)
        root.fillMode
      else
        Image.Stretch
    }
  }
}
