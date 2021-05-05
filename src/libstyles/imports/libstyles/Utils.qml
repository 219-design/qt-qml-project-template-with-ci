pragma Singleton

import QtQuick 2.12

Item {
  function centralPanelsOuterMargin(rootWidth) {
    return rootWidth * 0.08
  }

  function colorWithAlpha(color, alpha) {
    return Qt.hsla(color.hslHue, color.hslSaturation, color.hslLightness, alpha)
  }

  function percentOfArgumentDistanceCappedMinAndMax(percent, argDistance, min, max) {
    return Math.min(Math.max(argDistance * percent, min), max)
  }

  function percentOfAppHeightCappedMinAndMax(percent, min, max) {
    var h = Globals.rootHeight
    if (!h) {
      console.warn('unable to locate nonnull Globals.rootHeight')
      h = 800
    }
    return percentOfArgumentDistanceCappedMinAndMax(percent, h, min, max)
  }

  function percentOfAppWidthCappedMinAndMax(percent, min, max) {
    var w = Globals.rootWidth
    if (!w) {
      console.warn('unable to locate nonnull Globals.rootWidth')
      w = 400
    }
    return percentOfArgumentDistanceCappedMinAndMax(percent, w, min, max)
  }
}
