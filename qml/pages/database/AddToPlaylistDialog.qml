import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
    id: saveToList
    property string url
    allowedOrientations: Orientation.All
    canAccept: false

    SilicaListView {
        id: savedListView
        model: savedPlaylistsModel
        anchors.fill: parent
        header: DialogHeader {
            acceptText: qsTr("Select playlist")
            title: qsTr("Select playlist")
        }
        delegate: ListItem {
            Column {
                id: mainColumn
                anchors {
                    right: parent.right
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: listPadding
                    rightMargin: listPadding
                }
                Label {
                    text: modelData
                }
            }
            OpacityRampEffect {
                sourceItem: mainColumn
                slope: 3.5
                offset: 0.75
            }
            onClicked: {
                addSongToSaved([url, modelData])
                pageStack.pop()
            }
        }
    }
    Component.onDestruction: {
        clearPlaylists()
    }
}
