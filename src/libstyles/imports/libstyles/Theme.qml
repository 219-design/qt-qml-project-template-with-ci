import QtQuick 2.12
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
pragma Singleton

// If we need to expand this or make it configurable, then refer to:
// https://stackoverflow.com/questions/44389883/dynamically-change-qml-theme-at-runtime-on-mouseclick
Item {
  id: root

  // Useful online tools for adjusting the color palette:
  //   https://material.io/inline-tools/color/
  //   http://colormind.io/bootstrap/
  //   https://superdevresources.com/tools/color-shades#005ead
  property color primaryDark: "#802566"
  property color primaryMediumDark: "#a72a74"
  property color primaryMedium: "#d42e83"
  property color primaryMediumLight: "#e86cb0"
  property color primaryLight: "#f1bfdd"

  function setPrimary(index, color) {
    if (index == 0) {
      root.primaryDark = color
    } else if (index == 1) {
      root.primaryMediumDark = color
    } else if (index == 2) {
      root.primaryMedium = color
    } else if (index == 3) {
      root.primaryMediumLight = color
    } else if (index == 4) {
      root.primaryLight = color
    }
  }

  property color secondaryDark: "#511d6f"
  property color secondaryMediumDark: "#7b2a88"
  property color secondaryMedium: "#983597"
  property color secondaryMediumLight: "#cd95cb"
  property color secondaryLight: "#e0bfdf"

  function setSecondary(index, color) {
    if (index == 0) {
      root.secondaryDark = color
    } else if (index == 1) {
      root.secondaryMediumDark = color
    } else if (index == 2) {
      root.secondaryMedium = color
    } else if (index == 3) {
      root.secondaryMediumLight = color
    } else if (index == 4) {
      root.secondaryLight = color
    }
  }

  property color neutralDark: "#262527"
  property color neutralMediumDark: "#5a575c"
  property color neutralMedium: "#827e85"
  property color neutralMediumLight: "#a6a3a8"
  property color neutralLight: "#f2f2f3"

  function setNeutral(index, color) {
    if (index == 0) {
      root.neutralDark = color
    } else if (index == 1) {
      root.neutralMediumDark = color
    } else if (index == 2) {
      root.neutralMedium = color
    } else if (index == 3) {
      root.neutralMediumLight = color
    } else if (index == 4) {
      root.neutralLight = color
    }
  }

  property color accentDark: "#235c3c"
  property color accentMediumDark: "#318155"
  property color accentMedium: "#4bba7c"
  property color accentMediumLight: "#a3dcbc"
  property color accentLight: "#c8ead7"

  function setAccent(index, color) {
    if (index == 0) {
      root.accentDark = color
    } else if (index == 1) {
      root.accentMediumDark = color
    } else if (index == 2) {
      root.accentMedium = color
    } else if (index == 3) {
      root.accentMediumLight = color
    } else if (index == 4) {
      root.accentLight = color
    }
  }

  property color accentOtherDark: "#5a5428"
  property color accentOtherMediumDark: "#bcb383"
  property color accentOtherMedium: "#dad09e"
  property color accentOtherMediumLight: "#faefbc"
  property color accentOtherLight: "#fffeca"

  function setAccentOther(index, color) {
    if (index == 0) {
      root.accentOtherDark = color
    } else if (index == 1) {
      root.accentOtherMediumDark = color
    } else if (index == 2) {
      root.accentOtherMedium = color
    } else if (index == 3) {
      root.accentOtherMediumLight = color
    } else if (index == 4) {
      root.accentOtherLight = color
    }
  }

  property color genericButtonFill: neutralMedium
  property color primaryButtonFill: secondaryMedium

  property color helpOrInfoColor: "#3E8E61"
  property color successColor: "#80a05c" // common advice says to AVOID using theme/brand colors for success/fail/warning
  property color warningColor: "#fd9024"
  property color dangerColor: "#f44336"

  property font basicFont
  basicFont.bold: false
  basicFont.underline: false
  basicFont.pixelSize: 14
  basicFont.family: "arial"

  property font regIconFont
  regIconFont.bold: false
  regIconFont.underline: false
  regIconFont.pixelSize: 48
  regIconFont.family: Fonts.fAwesomeFamily

  property font solidIconFont
  solidIconFont.bold: false
  solidIconFont.underline: false
  solidIconFont.pixelSize: 48
  solidIconFont.family: Fonts.fAwesomeSolidFamily

  property font regIconStretchToMaxFitFont
  regIconStretchToMaxFitFont.bold: regIconFont.bold
  regIconStretchToMaxFitFont.underline: regIconFont.underline
  regIconStretchToMaxFitFont.pixelSize: 1000 // intentionally ridiculous. use with 'fontSizeMode: Text.Fit'
  regIconStretchToMaxFitFont.family: regIconFont.family

  property font solidIconStretchToMaxFitFont
  solidIconStretchToMaxFitFont.bold: solidIconFont.bold
  solidIconStretchToMaxFitFont.underline: solidIconFont.underline
  solidIconStretchToMaxFitFont.pixelSize: 1000 // intentionally ridiculous. use with 'fontSizeMode: Text.Fit'
  solidIconStretchToMaxFitFont.family: solidIconFont.family
}
