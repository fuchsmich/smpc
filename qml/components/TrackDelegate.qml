import QtQuick 2.2
import Sailfish.Silica 1.0

ListItem {
    property alias number: numberLbl.text
    property alias title: titleLbl.text
    property alias length: lengthLbl.text
    property alias artist: artistLbl.text

    contentHeight: mainColumn.height
    menu: ContextMenu {
        MenuItem {
            text: qsTr("Remove song")
            visible: !mDeleteRemorseRunning
            enabled: !mDeleteRemorseRunning
            onClicked: {
                mDeleteRemorseRunning = true
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
                //text: (index + 1) + ". "
                anchors {
                    verticalCenter: parent.verticalCenter
                }
            }
            Label {
                id: titleLbl
                clip: true
                wrapMode: Text.WrapAnywhere
                elide: Text.ElideRight
                //text: (title === "" ? filename + " " : title + " ")
                font.italic: (playing) ? true : false
                font.bold: (playing) ? true : false
                color: playing ? Theme.highlightColor : Theme.primaryColor
                anchors {
                    verticalCenter: parent.verticalCenter
                }
            }
            Label {
                id: lengthLbl
                //text: (length === 0 ? "" : " (" + lengthformated + ")")
                anchors {
                    verticalCenter: parent.verticalCenter
                }
            }
        }
        Label {
            id: artistLbl
//            text: (artist !== "" ? artist + " - " : "")
//                  + (album !== "" ? album : "")
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

    function remove() {
        remorseAction(qsTr("Deleting"), function () {
            deletePlaylistTrack(index)
            mDeleteRemorseRunning = false
        }, 3000)
    }
}
