// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
pragma Singleton

import QtQuick 2.12


// If we need to expand this or make it configurable, then refer to:
// https://stackoverflow.com/questions/44389883/dynamically-change-qml-theme-at-runtime-on-mouseclick
QtObject {
  // Useful online tools for adjusting the color palette:
  //   https://material.io/inline-tools/color/
  //   http://colormind.io/bootstrap/
  //   https://superdevresources.com/tools/color-shades#005ead
  property color primaryDark: '#802566'
  property color primaryMediumDark: '#a72a74'
  property color primaryMedium: '#d42e83'
  property color primaryMediumLight: '#e86cb0'
  property color primaryLight: '#f1bfdd'

  property color secondaryDark: '#511d6f'
  property color secondaryMediumDark: '#7b2a88'
  property color secondaryMedium: '#983597'
  property color secondaryMediumLight: '#cd95cb'
  property color secondaryLight: '#e0bfdf'

  property color neutralDark: '#262527'
  property color neutralMediumDark: '#5a575c'
  property color neutralMedium: '#827e85'
  property color neutralMediumLight: '#a6a3a8'
  property color neutralLight: '#f2f2f3'

  property color accentDark: '#235c3c'
  property color accentMediumDark: '#318155'
  property color accentMedium: '#4bba7c'
  property color accentMediumLight: '#a3dcbc'
  property color accentLight: '#c8ead7'

  property color accentOtherDark: '#5a5428'
  property color accentOtherMediumDark: '#bcb383'
  property color accentOtherMedium: '#dad09e'
  property color accentOtherMediumLight: '#faefbc'
  property color accentOtherLight: '#fffeca'

  property color genericButtonFill: neutralMedium
  property color primaryButtonFill: secondaryMedium

  property color helpOrInfoColor: '#3E8E61'
  property color successColor: '#80a05c' // common advice says to AVOID using theme/brand colors for success/fail/warning
  property color warningColor: '#fd9024'
  property color dangerColor: '#f44336'

  property font basicFont
  basicFont.bold: false
  basicFont.underline: false
  basicFont.pixelSize: 14
  basicFont.family: "arial"
}
