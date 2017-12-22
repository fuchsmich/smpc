import QtQuick 2.0
import Sailfish.Silica 1.0

ListItem {
    id: listItem
    property string albumTitle: ""
    property string artist: ""
    property string imageUrl: ""

    state: "artists"
    //    menu: contextMenu
    contentHeight: ((listImageSize  === 1) || (listImageSize  === 0)  ? Theme.itemSizeSmall :
                                                                        (listImageSize  === 2 ? Theme.itemSizeMedium : Theme.itemSizeLarge) )
    Row {
        id: mainRow
        height: parent.height
        anchors {
            right: parent.right
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: listPadding
            rightMargin: listPadding
        }
        spacing: Theme.paddingSmall

        Rectangle {
            id: imageRectangle
            color: Theme.rgba(Theme.highlightBackgroundColor,0.2)
            width: ( listImageSize !== 0 ) ? mainRow.height : 0
            height: mainRow.height
            Image{
                id: image
                anchors.fill: parent
                cache: false
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                /*sourceSize.width: width
                    sourceSize.height: height*/
                source: ( listImageSize === 0 ) ? "" : imageUrl
            }
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            Label {
                id: albumLabel
                visible: false
                text: albumTitle
            }
            Label {
                id: artistLabel
                text: (artist === "" ? qsTr("no artist tag") : artist)
            }
        }
    }
    OpacityRampEffect {
        sourceItem: mainRow
        slope: 3
        offset: 0.65
    }

    function playArtistRemorse() {
        remorseAction(qsTr("playing artist"), function () {
            playArtist(artist)
        }, 3000)
    }
    function addArtistRemorse() {
        remorseAction(qsTr("adding artist"), function () {
            addArtist(artist)
        }, 3000)
    }
    function playAlbumRemorse() {
        remorseAction(qsTr("playing album"), function () {
            playAlbum([artist, title])
        }, 3000)
    }
    function addAlbumRemorse() {
        remorseAction(qsTr("adding album"), function () {
            addAlbum([artist, title])
        }, 3000)
    }

    Component {
        id: artistContextMenu
        ContextMenu {
            MenuItem {
                text: qsTr("play artist")
                onClicked: {
                    if (artist !== "") {
                        playArtistRemorse()
                    }
                }
            }

            MenuItem {
                text: qsTr("add artist to list")
                onClicked: {
                    if (artist !== "") {
                        addArtistRemorse()
                    }
                }
            }
        }
    }

    Component {
        id: albumContextMenu
        ContextMenu {
            MenuItem {
                text: qsTr("play album")
                onClicked: {
                    if (title !== "") {
                        playAlbumRemorse()
                    }
                }
            }

            MenuItem {
                text: qsTr("add album to list")
                onClicked: {
                    if (title !== "") {
                        addAlbumRemorse()
                    }
                }
            }
        }
    }

    states: [
        State {
            name: "artists"
            PropertyChanges {
                target: listItem
                menu: artistContextMenu
                //                onClicked: {
                //                    listView.currentIndex = index;
                //                    artistClicked(artist)
                //                    pageStack.push(Qt.resolvedUrl("AlbumArtistListPage.qml"),{
                //                                       category: "albums"
                //                                   });
                //                }
            }
            //            PropertyChanges {
            //                target: image
            //                source: ( listImageSize === 0 ) ? "" : imageUrl
            //            }
        },
        State {
            name: "albums"
            PropertyChanges {
                target: listItem
                menu: albumContextMenu
                //                onClicked: {
                //                    listView.currentIndex = index;
                //                    albumClicked(artist, title);
                //                    pageStack.push(Qt.resolvedUrl("./AlbumTracksPage.qml"),
                //                                   {artistname:artist,albumname:albumTitle}); //?????
                //                }
            }
            PropertyChanges {
                target: albumLabel
                visible: true
            }
        }
    ]
}
