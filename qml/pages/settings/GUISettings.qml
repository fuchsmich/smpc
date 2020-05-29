import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    id: guisettingsPage
    PageHeader {
        id: header
        title: qsTr("GUI settings")
        anchors {
            right: parent.right
            left: parent.left
        }
    }

    SilicaFlickable {
        id: mainFlickable
        anchors.fill: parent
        contentHeight: mainColumn.height
        anchors.topMargin: header.height
        Column {
            id: mainColumn
            anchors {
                left: parent.left
                right: parent.right
            }

            ComboBox {
                label: qsTr("Album view:")
                anchors {
                    right: parent.right
                    left: parent.left
                }
                currentIndex: settings.gui.albumViewMode
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Grid")
                    }
                    MenuItem {
                        text: qsTr("List")
                    }
                    onActivated: settings.gui.albumViewMode = index
                }
            }

            ComboBox {
                label: qsTr("Artist view:")
                anchors {
                    right: parent.right
                    left: parent.left
                }
                currentIndex: settings.gui.artistViewMode
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Grid")
                    }
                    MenuItem {
                        text: qsTr("List")
                    }
                    onActivated: settings.gui.artistViewMode = index
                }
            }

            ComboBox {
                id: imageSizeCB
                label: qsTr("List image size:")
                anchors {
                    right: parent.right
                    left: parent.left
                }
                currentIndex: listImageSize
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Disabled")
                    }
                    MenuItem {
                        text: qsTr("Small")
                    }
                    MenuItem {
                        text: qsTr("Medium")
                    }
                    MenuItem {
                        text: qsTr("Large")
                    }
                }

                onValueChanged: {
                    if (currentIndex == 0) {
                        newSettingKey(["listImageSize", "0"])
                    } else if (currentIndex == 1) {
                        newSettingKey(["listImageSize", "1"])
                    } else if (currentIndex == 2) {
                        newSettingKey(["listImageSize", "2"])
                    } else if (currentIndex == 3) {
                        newSettingKey(["listImageSize", "3"])
                    }
                }
            }
            TextSwitch {
                id: sortAlbumsByYearSwitch
                text: qsTr("Sort albums of one artist by year")
                checked: sortAlbumsByYear
                onClicked: {
                    if (checked) {
                        newSettingKey(["sortAlbumsByYear", "1"])
                    } else {
                        newSettingKey(["sortAlbumsByYear", "0"])
                    }
                }
            }
            TextSwitch {
                id: albumArtistSwitch
                text: qsTr("Use albumartist in artists view")
                checked: artistsViewUseAlbumArtist
                onClicked: {
                    if (checked) {
                        newSettingKey(["artistsViewUseAlbumArtist", "1"])
                    } else {
                        newSettingKey(["artistsViewUseAlbumArtist", "0"])
                    }
                }
            }
            TextSwitch {
                id: coverNowPlayingSwitch
                text: qsTr("Show cover in now playing")
                checked: showCoverNowPlaying
                onClicked: {
                    if (checked) {
                        newSettingKey(["showCoverNowPlaying", "1"])
                    } else {
                        newSettingKey(["showCoverNowPlaying", "0"])
                    }
                    mCurrentSongPage = null
                }
            }
            TextSwitch {
                id: sectionInPlaylistSwitch
                text: qsTr("Show sections in playlists")
                checked: sectionsInPlaylist
                onClicked: {
                    if (checked) {
                        newSettingKey(["sectionsInPlaylist", "1"])
                    } else {
                        newSettingKey(["sectionsInPlaylist", "0"])
                    }
                    mPlaylistPage = null
                }
            }
            TextSwitch {
                id: sectionInSearchSwitch
                text: qsTr("Show sections in search")
                checked: sectionsInSearch
                onClicked: {
                    if (checked) {
                        newSettingKey(["sectionsInSearch", "1"])
                    } else {
                        newSettingKey(["sectionsInSearch", "0"])
                    }
                }
            }
            TextSwitch {
                id: showViewModeLandscapeSwitch
                text: qsTr("Use show mode in landscape")
                checked: useShowView
                onClicked: {
                    if (checked) {
                        newSettingKey(["showModeLandscape", "1"])
                    } else {
                        newSettingKey(["showModeLandscape", "0"])
                    }
                }
            }

            ComboBox {
                //id: imageSizeCB
                label: qsTr("Main Menu Button")
                anchors {
                    right: parent.right
                    left: parent.left
                }
                currentIndex: settings.gui.mainMenuButton
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Show saved playlists")
                    }
                    MenuItem {
                        text: qsTr("Shuffle all tracks")
                    }
                    onActivated: settings.gui.mainMenuButton = index
                }
            }
        }
    }
}
