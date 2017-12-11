import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../common/qml/components"
//import components 1.0

Page {
    id: mainPage
//    property var onReadyFunction: function() {}
    Connections {

    }

    allowedOrientations: Orientation.All
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height
        clip: true
        Column {
            id: column
            width: mainPage.width
            PageHeader {
                title: "SMPC"
            }
            Label {
                width: column.width
                horizontalAlignment: Text.AlignHCenter
                color: Theme.highlightColor
                text: connected ? qsTr("connected to: %1").arg(profilename) : qsTr(
                                      "disconnected")
            }
            MenuGrid {
                id: mainGrid
                menuModel: mainMenuModel
                onItemClicked: parseClickedMainMenu(ident)
            }
        }
    }

    Component.onCompleted: {
        mainMenuModel.append({
                                 name: qsTr("playlist"),
                                 ident: "playlist",
                                 icon: "image://theme/icon-m-document"
                             })
        mainMenuModel.append({
                                 name: qsTr("artists"),
                                 ident: "artists",
                                 icon: "image://theme/icon-m-mic"
                             })
        mainMenuModel.append({
                                 name: qsTr("albums"),
                                 ident: "albums",
                                 icon: "image://theme/icon-m-music"
                             })
        mainMenuModel.append({
                                 name: qsTr("files"),
                                 ident: "files",
                                 icon: "image://theme/icon-m-folder"
                             })
        mainMenuModel.append({
                                 name: qsTr("search"),
                                 ident: "search",
                                 icon: "image://theme/icon-m-search"
                             })
        mainMenuModel.append({
                                 name: qsTr("connect"),
                                 ident: "connectto",
                                 icon: "image://theme/icon-m-computer"
                             })
        mainMenuModel.append({
                                 name: qsTr("settings"),
                                 ident: "settings",
                                 icon: "image://theme/icon-m-developer-mode"
                             })
    }

    ListModel {
        id: mainMenuModel
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

    function parseClickedMainMenu(ident) {
        if (ident === "playlist") {
            if (connected) {
                pageStack.navigateForward(PageStackAction.Animated)
            }
        } else if (ident === "settings") {
            pageStack.push(Qt.resolvedUrl("settings/SettingsPage.qml"))
        } else if (ident === "currentsong") {
            if (connected)
                pageStack.push(currentsongpage)
            //                        if(connected)
            //                            pageStack.push(Qt.resolvedUrl("CurrentSong.qml"));
        } else if (ident === "albums") {
            artistname = ""
            if (connected) {
                requestAlbums()
                pageStack.push(Qt.resolvedUrl("../../common/qml/components/AlbumArtistListPage.qml"), {
                                   category: "albums"
                               })
            }
        } else if (ident === "artists") {
            if (connected) {
                requestArtists()
                pageStack.push(Qt.resolvedUrl("../../common/qml/components/AlbumArtistListPage.qml"), {
                                   category: "artists"
                               })
            }
        } else if (ident === "files") {
            if (connected)
                filesClicked("/")
        } else if (ident === "connectto") {
            pageStack.push(Qt.resolvedUrl("settings/ConnectServerPage.qml"))
        } else if (ident === "about") {
            aboutdialog.visible = true
            aboutdialog.version = versionstring
            aboutdialog.open()
        } else if (ident === "updatedb") {
            updateDB()
        } else if (ident === "search") {
            pageStack.push(Qt.resolvedUrl("database/SearchPage.qml"))
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Active) {
            //            pageStack.pushAttached(Qt.resolvedUrl("database/CurrentPlaylistPage.qml"));
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
