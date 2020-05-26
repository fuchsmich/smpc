import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
    Column {
        width: parent.width
        spacing: Theme.paddingMedium
        anchors.margins: Theme.paddingMedium
        DialogHeader {
            acceptText: qsTr("Add url")
        }
        Label {
            x: Theme.paddingLarge
            text: qsTr("Enter url:")
        }
        TextField {
            id: urlInputField
            width: parent.width
            label: qsTr("Input url (http://, file://, etc)")
            placeholderText: label
            inputMethodHints: Qt.ImhNoPredictiveText
            focus: true
        }
    }
    onDone: {
        if (result === DialogResult.Accepted) {
            ctl.player.playlist.addTrack(urlInputField.text)
        }
        urlInputField.text = ""
        urlInputField.focus = false
    }
    onOpened: {
        urlInputField.forceActiveFocus()
    }
}
