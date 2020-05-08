import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../components"

Page {
    id: currentPlaylistPage
    allowedOrientations: Orientation.All
    //FIXME what for?
    //property int lastIndex: lastsongid

    RemorsePopup {
        id: remorse
    }

    Component.onDestruction: {
        mPlaylistPage = null
    }

    SilicaListView {
        id: playlistView
        property bool mDeleteRemorseRunning: false

        function scrollToCurrentItem() {
            playlistView.positionViewAtIndex(ctl.player.playbackStatus.id, ListView.Center)
        }

        anchors {
            fill: parent
        }
        clip: true
        //cacheBuffer: 0

        currentIndex: ctl.player.playbackStatus.id //lastsongid
        highlightFollowsCurrentItem: true
        highlightMoveDuration: 0

        model: ctl.player.playlist
        delegate: TrackDelegate {
            index: model.index
            number: "%1.".arg(model.index + 1)
            title: (model.title === "" ? model.filename + " " : model.title + " ")
            length: (model.length === 0 ? "" : " (" + lengthformated + ")")
            artist: (model.artist !== "" ? model.artist + " - " : "")
                    + (model.album !== "" ? model.album : "")
            album: model.album
        }

        quickScrollEnabled: jollaQuickscroll
        header: PageHeader {
            title: qsTr("Playlist")
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("Add url")
                onClicked: {
                    pageStack.push(urlInputDialog)
                }
            }
            MenuItem {
                text: qsTr("Delete playlist")
                onClicked: {
                    remorse.execute("Deleting playlist", function () {
                        ctl.player.deletePlaylist()
                    })
                }
            }
            MenuItem {
                text: qsTr("Save playlist")
                onClicked: {
                    pageStack.push(saveplaylistDialog)
                }
            }
            MenuItem {
                text: qsTr("Open playlist")
                onClicked: {
                    requestSavedPlaylists()
                    pageStack.push(Qt.resolvedUrl("SavedPlaylistsPage.qml"))
                }
            }
            MenuItem {
                text: qsTr("Jump to playing song")
                onClicked: {
//                    playlistView.currentIndex = -1
//                    playlistView.currentIndex = ctl.player.playbackStatus.id //lastsongid
                    playlistView.scrollToCurrentItem()
                }
            }
        }

        SpeedScroller {
            listview: playlistView
        }
        ScrollDecorator {
        }

        section {
            delegate: Loader {
                active: sectionsInPlaylist && visible
                height: sectionsInPlaylist ? Theme.itemSizeMedium : 0
                width: parent.width
                sourceComponent: PlaylistSectionDelegate {
                    width: undefined
                }
            }
            property: "section"
        }
    }

    SavePlaylistDialog {
        id: saveplaylistDialog
    }

    URLInputDialog {
        id: urlInputDialog
    }

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            //playlistView.positionViewAtIndex(ctl.player.playbackStatus.id, ListView.Center)
            playlistView.scrollToCurrentItem()
        } else if (status === PageStatus.Active) {
            //            pageStack.pushAttached(Qt.resolvedUrl("CurrentSong.qml"));
            if (mCurrentSongPage == undefined) {
                var currentSongComponent = Qt.createComponent(
                            Qt.resolvedUrl("CurrentSong.qml"))
                mCurrentSongPage = currentSongComponent.createObject(mainWindow)
            }
            pageStack.pushAttached(mCurrentSongPage)
        }
    }

    function parseClickedPlaylist(index) {
        playPlaylistTrack(index)
    }
    onOrientationTransitionRunningChanged: {
        if (!orientationTransitionRunning) {
//            playlistView.currentIndex = -1
//            playlistView.currentIndex = ctl.player.playbackStatus.id
            playlistView.scrollToCurrentItem()
        }
    }
//    onLastIndexChanged: {
//        playlistView.currentIndex = -1
//        playlistView.currentIndex = lastIndex
//    }


    /* FIXME really bad workaround for segmentation fault.
       Otherwise QML/Qt seems to crash if model changes significantly on contextmenu actions*/
    Timer {
        id: playNextWOTimer
        property int index
        interval: 250
        repeat: false
        onTriggered: {
            console.debug("Send signal: " + index)
            playPlaylistSongNext(index)
        }

        function windUp(pIndex) {
            console.debug("Workaround timer windup")
            index = pIndex
            start()
        }
    }
}
