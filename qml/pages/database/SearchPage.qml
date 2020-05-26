import QtQuick 2.2
import Sailfish.Silica 1.0
import "../../components"

Page {
    id: searchpage
    property int currentindex: -1
    property string selectedsearch

    Drawer {
        id: mainDrawer
        anchors.fill: parent
        //        anchors.bottomMargin: quickControlPanel.visibleSize
        open: true
        dock: Dock.Bottom
        backgroundSize: searchhead.height
        background: Column {
            id: searchhead
            spacing: Theme.paddingMedium
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            SearchField {
                id: searchfield
                anchors {
                    left: parent.left
                    right: parent.right
                }
                placeholderText: qsTr("Search value")
                text: ""
                //inputMethodHints: Qt.ImhNoPredictiveText
                EnterKey.onClicked: {
                    startSearch()
                }
            }

            ComboBox {
                id: searchforcombobox
                label: qsTr("Search for:")
                anchors {
                    left: parent.left
                    right: parent.right
                }
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Titles")
                    }
                    MenuItem {
                        text: qsTr("Albums")
                    }
                    MenuItem {
                        text: qsTr("Artists")
                    }
                    MenuItem {
                        text: qsTr("Files")
                    }
                }
            }
        }

        SilicaListView {
            id: searchsongListView
            anchors {
                fill: parent
                //bottomMargin: mainDrawer.open ? undefined : quickControlPanel.visibleSize
            }
            ScrollDecorator {
            }
            quickScrollEnabled: jollaQuickscroll
            SpeedScroller {
                listview: searchsongListView
            }

            header: PageHeader {
                title: qsTr("Search")
                width: searchsongListView.width
            }
            //            populate: Transition {
            //                NumberAnimation { properties: "x"; from:albumsongs_list_view.width*2 ;duration: populateDuration }
            //            }
            clip: true
            model: tracksModel

            PullDownMenu {
                enabled: searchsongListView.model !== undefined
                MenuItem {
                    text: qsTr("New search")
                    visible: searchsongListView.model !== undefined
                    onClicked: {
                        newSearch()
                    }
                }
                MenuItem {
                    text: qsTr("Add all results")
                    visible: searchsongListView.model !== undefined
                    onClicked: {
                        ctl.player.deletePlaylist()
                        addlastsearch()
                    }
                }
                MenuItem {
                    text: qsTr("Play all results")
                    visible: searchsongListView.model !== undefined
                    onClicked: {
                        ctl.player.deletePlaylist()
                        addlastsearch()
                        playPlaylistTrack(0)
                    }
                }
            }

            section {
                delegate: Loader {
                    active: sectionsInSearch && visible
                    height: sectionsInSearch ? Theme.itemSizeMedium : 0
                    width: parent.width
                    sourceComponent: PlaylistSectionDelegate {
                        width: undefined
                    }
                }
                property: "section"
            }

            delegate: ListItem {
                menu: contextMenu
                contentHeight: Theme.itemSizeSmall
                Column {
                    id: mainColumn
                    clip: true
                    height: (trackRow + artistRow
                             >= Theme.itemSizeSmall ? trackRow + artistRow : Theme.itemSizeSmall)
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
                            text: (index + 1) + ". "
                            anchors {
                                verticalCenter: parent.verticalCenter
                            }
                        }
                        Label {
                            wrapMode: Text.WrapAnywhere
                            elide: Text.ElideRight
                            text: (title === "" ? filename : title)
                            anchors {
                                verticalCenter: parent.verticalCenter
                            }
                        }
                        Label {
                            text: (length === 0 ? "" : " (" + lengthformated + ")")
                            anchors {
                                verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                    Label {
                        id: artistRow
                        text: (artist !== "" ? artist + " - " : "") + (album !== "" ? album : "")
                        color: Theme.secondaryColor
                        font.pixelSize: Theme.fontSizeSmall
                    }
                }
                onClicked: {
                    albumTrackClicked(title, album, artist, lengthformated,
                                      path, year, tracknr, trackmbid,
                                      artistmbid, albummbid)
                }
                function playTrackRemorse() {
                    remorseAction(qsTr("Playing track"), function () {
                        ctl.player.playlist.playTrack(path)
                    }, 3000)
                }
                function addTrackRemorse() {
                    remorseAction(qsTr("Adding track"), function () {
                        ctl.player.playlist.addTrack(path)
                    }, 3000)
                }

                function playAlbumRemorse() {
                    remorseAction(qsTr("Playing album"), function () {
                        ctl.player.playlist.playAlbum("", album)
                    }, 3000)
                }
                function addAlbumRemorse() {
                    remorseAction(qsTr("Adding album"), function () {
                        ctl.player.playlist.addAlbum("", album)
                    }, 3000)
                }
                function addTrackAfterCurrentRemorse() {
                    remorseAction(qsTr("Adding track"), function () {
                        ctl.player.playlist.addTrackAfterCurrent(path)
                    }, 3000)
                }
                Component {
                    id: contextMenu
                    ContextMenu {
                        property int lastHeight: 0
                        MenuItem {
                            text: qsTr("Play track")
                            onClicked: {
                                playTrackRemorse()
                            }
                        }

                        MenuItem {
                            text: qsTr("Add track to list")
                            onClicked: {
                                addTrackRemorse()
                            }
                        }
                        MenuItem {
                            text: qsTr("Play after current")
                            onClicked: {
                                addTrackAfterCurrentRemorse()
                            }
                        }
                        MenuItem {
                            text: qsTr("Add album to list")
                            onClicked: {
                                addAlbumRemorse()
                            }
                        }
                        MenuItem {
                            text: qsTr("Play album")
                            onClicked: {
                                playAlbumRemorse()
                            }
                        }

                        MenuItem {
                            text: qsTr("Add to saved list")
                            onClicked: {
                                requestSavedPlaylists()
                                pageStack.push(Qt.resolvedUrl(
                                                   "AddToPlaylistDialog.qml"), {
                                                   "url": path
                                               })
                            }
                        }
                    }
                }
            }
        }
    }
    function startSearch() {
        mainDrawer.hide()
        var searchfor
        switch (searchforcombobox.currentIndex) {
        case 0:
            searchfor = "title"
            break
        case 1:
            searchfor = "album"
            break
        case 2:
            searchfor = "artist"
            break
        case 3:
            searchfor = "file"
            break
        }

        requestSearch([searchfor, searchfield.text])
        searchsongListView.forceActiveFocus()
    }

    function newSearch() {
        searchfield.text = ""
        clearTrackList()
        mainDrawer.show()
    }

    Component.onDestruction: {
        clearTrackList()
    }
}
