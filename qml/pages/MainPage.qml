import QtQuick 2.2
import Sailfish.Silica 1.0
import "../components"
import QtQml.Models 2.2

Page {
    id: mainPage
    PageHeader {
        id: mainHeader
        title: "SMPC"
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
        }
    }
    Label {
        id: connectedLabel
        anchors {
            top: mainHeader.bottom
            right: parent.right
            left: parent.left
        }
        horizontalAlignment: Text.AlignHCenter
        color: Theme.highlightColor
        text: connected ? qsTr("Connected to: %1").arg(profilename) : qsTr(
                              "Disconnected")
    }
    SilicaFlickable {
        anchors {
            top: connectedLabel.bottom
            bottom: parent.bottom
            right: parent.right
            left: parent.left
        }
        contentHeight: mainGrid.height
        clip: true
        Item {
            height: mainGrid.height
            width: parent.width
            Grid {
                id: mainGrid

                columns: Screen.sizeCategory
                         >= Screen.Large ? 3 : (orientation === Orientation.Landscape
                                                || orientation
                                                === Orientation.LandscapeInverted) ? 4 : 2
                anchors.horizontalCenter: parent.horizontalCenter
                Repeater {
                    model: ObjectModel {
                        MainMenuItem {
                            text: qsTr("Playlist")
                            iconSource: "image://theme/icon-m-document"
                            onClicked: if (connected)
                                           pageStack.push(Qt.resolvedUrl("database/CurrentPlaylistPage.qml"))
                        }
                        MainMenuItem {
                            text: qsTr("Artists")
                            iconSource: "image://theme/icon-m-mic"
                            enabled: connected
                            onClicked:{
                                if (connected) {
                                    requestArtists()
                                    pageStack.push(Qt.resolvedUrl("database/ArtistListPage.qml"))
                                }
                            }
                        }

                        MainMenuItem {
                            text: qsTr("Albums")
                            iconSource: "image://theme/icon-m-music"
                            onClicked: {
                                artistname = ""
                                if (connected) {
                                    requestAlbums()
                                    pageStack.push(Qt.resolvedUrl("database/AlbumListPage.qml"), {
                                                       "artistname": artistname
                                                   })
                                }
                            }
                        }

                        MainMenuItem {
                            text: qsTr("Files")
                            iconSource: "image://theme/icon-m-folder"
                            onClicked: if (connected) filesClicked("/")
                        }

                        MainMenuItem {
                            text: qsTr("Search")
                            iconSource: "image://theme/icon-m-search"
                            onClicked: if (connected) pageStack.push(Qt.resolvedUrl("database/SearchPage.qml"))
                        }

                        MainMenuItem {
                            text: qsTr("Connect")
                            iconSource: "image://theme/icon-m-computer"
                            onClicked: pageStack.push(Qt.resolvedUrl("settings/ConnectServerPage.qml"))
                        }
                        MainMenuItem {
                            text: qsTr("Settings")
                            iconSource: "image://theme/icon-m-developer-mode"
                            onClicked: pageStack.push(Qt.resolvedUrl("settings/SettingsPage.qml"))
                        }
                    }
                }
            }
        }
    }



    Timer {
        id: showCurrentSongTimer
        interval: 15000
        repeat: false
        onTriggered: {
            if (connected) {
                pageStack.navigateForward(PageStackAction.Animated)
            }
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Active) {
            if (mPlaylistPage == undefined) {
                /* Check if running on large device and load corresponding page */
                if (Screen.sizeCategory >= Screen.Large) {
                    var playlistComponent = Qt.createComponent(
                                Qt.resolvedUrl(
                                    "database/CurrentPlaylistPage_large.qml"))
                    var playlistPage = playlistComponent.createObject(
                                mainWindow)
                } else {
                    var playlistComponent = Qt.createComponent(
                                Qt.resolvedUrl(
                                    "database/CurrentPlaylistPage.qml"))
                    var playlistPage = playlistComponent.createObject(
                                mainWindow)
                }
                mPlaylistPage = playlistPage
            }

            pageStack.pushAttached(mPlaylistPage)
            showCurrentSongTimer.start()
        } else if (status === PageStatus.Deactivating) {
            if (showCurrentSongTimer.running) {
                showCurrentSongTimer.stop()
            }
        }
    }
}
