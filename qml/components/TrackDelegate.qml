import QtQuick 2.2
import Sailfish.Silica 1.0

ListItem {
    id: item

    property int index: -1
    property alias number: numberLbl.text
    property alias title: titleLbl.text
    property alias length: lengthLbl.text
    property alias artist: artistLbl.text
    property string album: ""

    function remove() {
        remorseAction(qsTr("Deleting"), function () {
            ctl.player.playlist.deleteTrack(index)
            item.ListView.view.mDeleteRemorseRunning = false
        }, mainWindow.remorseTimeout)
    }

    contentHeight: mainColumn.height

    Column {
        id: mainColumn
        clip: true
        height: Math.max(trackRow.height + artistLbl.height, Theme.itemSizeSmall)
        anchors {
            right: parent.right
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: listPadding
            rightMargin: listPadding
        }
        Row {
            id: trackRow
            Label {
                id: numberLbl
                anchors {
                    verticalCenter: parent.verticalCenter
                }
            }
            Label {
                id: titleLbl
                clip: true
                wrapMode: Text.WrapAnywhere
                elide: Text.ElideRight
                font.italic: playing
                font.bold: playing
                color: playing ? Theme.highlightColor : Theme.primaryColor
                anchors {
                    verticalCenter: parent.verticalCenter
                }
            }
            Label {
                id: lengthLbl
                anchors {
                    verticalCenter: parent.verticalCenter
                }
            }
        }
        Label {
            id: artistLbl
            color: Theme.secondaryColor
            font.pixelSize: Theme.fontSizeSmall
        }
    }
    OpacityRampEffect {
        sourceItem: mainColumn
        slope: 3.5
        offset: 0.75
    }

    onClicked: {
        ListView.view.currentIndex = index
        if (!playing) {
            parseClickedPlaylist(index)
        } else {
            pageStack.navigateForward(PageStackAction.Animated)
        }
    }

    menu: ContextMenu {
        MenuItem {
            text: qsTr("Remove song")
            visible: !item.ListView.view.mDeleteRemorseRunning
            enabled: !item.ListView.view.mDeleteRemorseRunning
            onClicked: {
                item.ListView.view.mDeleteRemorseRunning = true
                remove()
            }
        }

        MenuItem {
            text: qsTr("Show artist")
            onClicked: {
                artistClicked(artist)
                pageStack.push(Qt.resolvedUrl(
                                   "AlbumListPage.qml"), {
                                   "artistname": artist
                               })
            }
        }

        MenuItem {
            text: qsTr("Show album")
            onClicked: {
                albumClicked("", album)
                pageStack.push(Qt.resolvedUrl(
                                   "AlbumTracksPage.qml"), {
                                   "artistname": "",
                                   "albumname": album
                               })
            }
        }
        MenuItem {
            visible: !playing
            text: qsTr("Play as next")
            onClicked: {
                playNextWOTimer.windUp(index)
            }
        }

        MenuItem {
            visible: playing
            text: qsTr("Show information")
            onClicked: pageStack.navigateForward(
                           PageStackAction.Animated)
        }

        MenuItem {
            text: qsTr("Add to saved list")
            onClicked: {
                requestSavedPlaylists()
                pageStack.push(
                            Qt.resolvedUrl(
                                "AddToPlaylistDialog.qml"),
                            {
                                "url": path
                            })
            }
        }
    }
}
