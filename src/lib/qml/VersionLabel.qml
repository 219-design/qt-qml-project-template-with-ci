import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.14
import libstyles 1.0

Label {
  font: Theme.basicFont
  color: Theme.primaryDark
  text: versionInfoGitHash + " - Built on: " + versionInfoBuildDateString
}
