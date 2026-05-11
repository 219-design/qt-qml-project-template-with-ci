import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.14
import libstyles 1.0

Label {
  property bool verBool_: versionInfoGitHash
  property string ver_: (!!verBool_) ? versionInfoGitHash : "$git-info-here$"

  property bool builddateBool_: versionInfoBuildDateString
  property string builddate_: {
    if (!!builddateBool_) {
      versionInfoBuildDateString
    } else {
      Qt.formatDateTime(new Date(), "yyyy-MM-dd")
    }
  }

  font: Theme.basicFont
  text: ver_ + " - Built on: " + builddate_
  horizontalAlignment: Text.AlignHCenter
  verticalAlignment: Text.AlignVCenter
}
