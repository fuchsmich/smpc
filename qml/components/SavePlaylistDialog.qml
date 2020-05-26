import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
    Column {
        width: parent.width
        spacing: Theme.paddingMedium
        anchors.margins: Theme.paddingMedium
        DialogHeader {
            acceptText: qsTr("Save playlist")
        }
        Label {
            x: Theme.paddingLarge
            text: qsTr("Playlist name:")
        }
        TextField {
            id: playlistNameField
            width: parent.width
            label: qsTr("Input playlist name")
            placeholderText: label
            inputMethodHints: Qt.ImhNoPredictiveText
        }
    }
    onDone: {
        if (result === DialogResult.Accepted) {
            savePlaylist(playlistNameField.text)
        }
        playlistNameField.text = ""
        playlistNameField.focus = false
    }
    onOpened: {
        playlistNameField.focus = true
    }
}
