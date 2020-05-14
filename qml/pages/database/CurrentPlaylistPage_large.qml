import QtQuick 2.2
import Sailfish.Silica 1.0
import "../../components"

Page {
    id: currentPlaylistPage
    allowedOrientations: Orientation.All
    property int lastIndex: lastsongid
    property bool mDeleteRemorseRunning: false

    Component.onDestruction: {
        mPlaylistPage = null
    }

    RemorsePopup {
        id: remorse
    }

    Row {
        anchors.fill: parent
        SilicaListView {
            id: playlistView
            clip: true
            currentIndex: lastsongid

            cacheBuffer: 0
            anchors {
                top: parent.top
                bottom: parent.bottom
            }

            width: parent.width / 2

            model: ctl.player.playlist
            delegate: TrackDelegate {
                index: model.index
                number: "%1. ".arg(model.index + 1)
                title: (model.title === "" ? model.filename + " " : model.title + " ")
                length: (model.length === 0 ? "" : " (" + lengthformated + ")")
                artist: (model.artist !== "" ? model.artist + " - " : "")
                        + (model.album !== "" ? model.album : "")
                album: model.album
                playing: model.playing
                path: model.path

                onClicked: {
                    ListView.view.currentIndex = index
                    if (!playing) {
                        ctl.player.playlist.playTrackNumber(index)
                    } else {
                        pageStack.navigateForward(PageStackAction.Animated)
                    }
                }
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Remove song")
                        visible: !playlistView.mDeleteRemorseRunning
                        enabled: !playlistView.mDeleteRemorseRunning
                        onClicked: {
                            playlistView.mDeleteRemorseRunning = true
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
            quickScrollEnabled: jollaQuickscroll
            highlightFollowsCurrentItem: true
            highlightMoveDuration: 0
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
                        playlistView.currentIndex = -1
                        playlistView.currentIndex = lastsongid
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

        // Main row end

        // Current song pane
        Item {
            id: currentSongPane
            anchors {
                top: parent.top
                bottom: parent.bottom
            }
            width: parent.width / 2

            Drawer {
                id: mainDrawer
                dock: Dock.Bottom
                anchors.fill: parent
                open: true

                SilicaFlickable {
                    id: infoFlickable
                    anchors.fill: parent
                    PullDownMenu {
                        MenuItem {
                            text: qsTr("Show all tracks from album")
                            visible: mAlbum === "" ? false : true
                            onClicked: {
                                albumClicked("", mAlbum)
                                pageStack.push(Qt.resolvedUrl(
                                                   "AlbumTracksPage.qml"), {
                                                   "artistname": "",
                                                   "albumname": mAlbum
                                               })
                            }
                        }
                        MenuItem {
                            text: qsTr("Show albums from artist")
                            visible: mArtist === "" ? false : true
                            onClicked: {
                                artistClicked(mArtist)
                                pageStack.push(Qt.resolvedUrl(
                                                   "AlbumListPage.qml"), {
                                                   "artistname": mArtist
                                               })
                            }
                        }
                    }
                    contentHeight: contentColumn.height
                    clip: true
                    Column {
                        id: contentColumn

                        clip: true
                        anchors {
                            right: parent.right
                            left: parent.left
                        }

                        Column {
                            id: subColumn
                            anchors {
                                left: parent.left
                                right: parent.right
                                leftMargin: listPadding
                                rightMargin: listPadding
                            }

                            ToggleImage {
                                enabled: showCoverNowPlaying
                                visible: showCoverNowPlaying
                                anchors {
                                    horizontalCenter: parent.horizontalCenter
                                }
                                id: coverImage
                                property int calcheight: (infoFlickable.height
                                                          - (titleText.height + albumText.height
                                                             + artistText.height))
                                height: showCoverNowPlaying ? (calcheight > (contentColumn.width - listPadding * 2) ? (contentColumn.width - listPadding * 2) : calcheight) : 0
                                width: height
                                fillMode: Image.PreserveAspectFit
                                sourceprimary: coverimageurl
                                sourcesecondary: artistimageurl
                                active: visible
                                Rectangle {
                                    color: Theme.rgba(
                                               Theme.highlightBackgroundColor,
                                               Theme.highlightBackgroundOpacity)
                                    anchors.fill: parent
                                    visible: (!coverImage.ready
                                              && showCoverNowPlaying)
                                    Image {
                                        anchors.fill: parent
                                        source: "qrc:images/pictogram.svg"
                                        sourceSize.width: Screen.width / 2
                                        sourceSize.height: Screen.width / 2
                                    }
                                }
                            }

                            ScrollLabel {
                                id: titleText
                                text: mTitle
                                color: Theme.primaryColor
                                font.pixelSize: Theme.fontSizeMedium
                                anchors {
                                    left: parent.left
                                    right: parent.right
                                }
                            }
                            ScrollLabel {
                                id: albumText
                                text: mAlbum
                                color: Theme.primaryColor
                                font.pixelSize: Theme.fontSizeMedium
                                anchors {
                                    left: parent.left
                                    right: parent.right
                                }
                            }
                            ScrollLabel {
                                id: artistText
                                text: mArtist
                                color: Theme.primaryColor
                                font.pixelSize: Theme.fontSizeMedium
                                anchors {
                                    left: parent.left
                                    right: parent.right
                                }
                            }

                            Label {
                                text: qsTr("Track nr:")
                                color: Theme.secondaryColor
                                font.pixelSize: Theme.fontSizeSmall
                                anchors {
                                    left: parent.left
                                }
                            }
                            Label {
                                id: nrText
                                text: mTrackNr
                                color: Theme.primaryColor
                                font.pixelSize: Theme.fontSizeMedium
                                wrapMode: "WordWrap"
                                //                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Label {
                                text: qsTr("Playlist nr:")
                                color: Theme.secondaryColor
                                font.pixelSize: Theme.fontSizeSmall
                                anchors {
                                    left: parent.left
                                }
                            }
                            Label {
                                id: playlistnrText
                                text: (lastsongid + 1) + " / " + mPlaylistlength
                                color: Theme.primaryColor
                                font.pixelSize: Theme.fontSizeMedium
                                wrapMode: "WordWrap"
                                //                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Label {
                                text: qsTr("Bitrate:")
                                color: Theme.secondaryColor
                                font.pixelSize: Theme.fontSizeSmall
                            }
                            Label {
                                id: bitrateText
                                text: mBitrate
                                color: Theme.primaryColor
                                font.pixelSize: Theme.fontSizeMedium
                                wrapMode: "WordWrap"
                                //                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Label {
                                text: qsTr("Properties:")
                                color: Theme.secondaryColor
                                font.pixelSize: Theme.fontSizeSmall
                            }
                            Label {
                                id: audiopropertiesText
                                text: mAudioProperties
                                color: Theme.primaryColor
                                font.pixelSize: Theme.fontSizeMedium
                                wrapMode: "WordWrap"
                                //                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Label {
                                text: qsTr("URI:")
                                color: Theme.secondaryColor
                                font.pixelSize: Theme.fontSizeSmall
                            }
                            Label {
                                id: fileText
                                text: mUri
                                color: Theme.primaryColor
                                font.pixelSize: Theme.fontSizeMedium
                                wrapMode: "WrapAnywhere"

                                anchors {
                                    left: parent.left
                                    right: parent.right
                                }
                            }
                        }
                    }
                }

                //backgroundSize: volumeControl.height + positionSlider.height + buttonRow.height
                backgroundSize: backgroundColumn.height
                background: Column {
                    id: backgroundColumn
                    width: parent.width
                    Item {
                        id: volumeControl
                        width: parent.width
                        height: volumeSlider.height + Theme.paddingMedium
                        state: "sliderInvisible"
                        states: [
                            State {
                                name: "sliderVisible"
                                PropertyChanges {
                                    target: volumeSlider
                                    enabled: true
                                    opacity: 1.0
                                }
                                PropertyChanges {
                                    target: volumeButton
                                    enabled: false
                                    opacity: 0.0
                                }
                            },
                            State {
                                name: "sliderInvisible"
                                PropertyChanges {
                                    target: volumeSlider
                                    enabled: false
                                    opacity: 0.0
                                }
                                PropertyChanges {
                                    target: volumeButton
                                    enabled: true
                                    opacity: 1.0
                                }
                            }
                        ]

                        transitions: [
                            Transition {
                                NumberAnimation {
                                    properties: "opacity"
                                    duration: 500
                                }
                            }
                        ]

                        IconButton {
                            id: volumeButton
                            anchors.centerIn: parent
                            icon.source: "image://theme/icon-m-speaker"
                            onClicked: {
                                volumeControl.state = "sliderVisible"
                                volumeSliderFadeOutTimer.start()
                            }
                            icon.onStatusChanged: {
                                if (icon.status == Image.Error) {
                                    // Try old icon name before Sailfish 2.0
                                    icon.source = "image://theme/icon-status-volume-max"
                                }
                            }
                        }

                        VolumeSlider {
                            id: volumeSlider
                            width: parent.width
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Timer {
                            id: volumeSliderFadeOutTimer
                            interval: 3000
                            repeat: false
                            onTriggered: {
                                volumeControl.state = "sliderInvisible"
                            }
                        }
                    }

                    PositionSlider {
                        id: positionSlider
                        width: parent.width
                        onPressedChanged: {
                            mPositionSliderActive = pressed
                        }
                    }

                    PlaybackControls {}
                }
            }
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
            playlistView.positionViewAtIndex(lastsongid, ListView.Center)
            quickControlPanel.hideControl = true
        } else if (status === PageStatus.Active) {

            if (mCurrentSongPage == undefined) {
                var currentSongComponent = Qt.createComponent(
                            Qt.resolvedUrl("CurrentSong_large.qml"))
                mCurrentSongPage = currentSongComponent.createObject(mainWindow)
            }
            pageStack.pushAttached(mCurrentSongPage)
            quickControlPanel.hideControl = true
        } else if (status === PageStatus.Deactivating) {
            quickControlPanel.hideControl = false
        }
    }

//    function parseClickedPlaylist(index) {
//        playPlaylistTrack(index)
//    }
    onOrientationTransitionRunningChanged: {
        if (!orientationTransitionRunning) {
            playlistView.currentIndex = -1
            playlistView.currentIndex = lastsongid
        }
    }
    onLastIndexChanged: {
        playlistView.currentIndex = -1
        playlistView.currentIndex = lastIndex
    }


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
