
/*
Declaration of QML Imports required by the app.

This is necessary because of the way qmlimportscanner works.  If these imports
are not declared, qmake will not recognize them, and QtQuick will not be
packaged with statically built apps (i.e. iOS) and imported at runtime.

https://forum.qt.io/topic/56748/what-s-the-equivalent-of-macdeployqt-s-qmldir-option-for-ios-builds/3

Keep this up to date by periodically running:
grep -rIw import src/ | awk -F: '{print $2}' | sort | uniq

*/
import QtGraphicalEffects 1.12
import QtQuick 2.1
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Universal 2.2
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.14
import QtQuick.Window 2.1

QtObject {}
