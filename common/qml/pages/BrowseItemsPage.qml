import QtQuick 2.0
import Sailfish.Silica 1.0

import "_private"

Page {
    id: page
    property string category: "artists" //(artists|albums)
    property var model
    property string pageTitle: ""
    property int lastIndex: -1
    property int lastOrientation
    property string artistname: ""

//    onModelChanged: console.log(model.count)

    allowedOrientations: Orientation.All

    Loader {
        id: contentLoader
        anchors.fill: parent
    }

    Component {
        id: listViewComp
        BrowserListView {
            id: listView
            pageTitle: page.pageTitle
//            artistname: page.artistname

            model: page.model
            delegate: BrowserListItem {
                state: page.category
                albumTitle: (typeof model.title !== "undefined" ? model.title : "") + model.date
                artist: model.artist
                imageUrl: (typeof model.coverURL !== "undefined"
                           ? model.coverURL : typeof model.imageURL !== "undefined"
                             ? model.imageURL : "")
                onClicked: {
                    if (page.category == "artists") {
                        artistClicked(artist)
                        pageStack.push(Qt.resolvedUrl("BrowseItemsPage.qml"),
                                       { category: "albums", artistname: model.artist });
                    } else  if (page.category == "albums") {
                        albumClicked(artist, albumTitle);
                        pageStack.push(Qt.resolvedUrl("AlbumTracksPage.qml"),
                                       { artistname: artist, albumname: albumTitle });
                    }
                }
            }
            section.property: (artistname !== "" && artistsViewUseAlbumArtist ? 'date' : 'sectionprop')
        }
    }

    Component {
        id: gridView
        BrowserGridView {
            model: page.model
            delegate: BrowserGridItem {
//                state: page.category
                albumTitle: (typeof model.title !== "undefined" ? model.title : "")
                artist: model.artist
                imageUrl: (typeof model.coverURL !== "undefined"
                           ? model.coverURL : typeof model.imageURL !== "undefined"
                             ? model.imageURL : "")
                onClicked: {
                    if (page.category == "artists") {
                        artistClicked(artist)
                        pageStack.push(Qt.resolvedUrl("BrowseItemsPage.qml"),
                                       { category: "albums", artistname: model.artist });
                    } else  if (page.category == "albums") {
                        albumClicked(artist, albumTitle);
                        pageStack.push(Qt.resolvedUrl("AlbumTracksPage.qml"),
                                       { artistname: artist, albumname: albumTitle });
                    }
                }
            }
        }
    }

    Component {
        id: showView
        BrowserPathView {
            model: page.model
        }
    }

    states: [
        State {
            name: "ArtistsListView"
            when: ((orientation === Orientation.Portrait) || (orientation === Orientation.PortraitInverted))
                  && artistView === 1
                  && category === "artists"
            PropertyChanges {
                target: contentLoader
                sourceComponent: listViewComp
            }
            PropertyChanges {
                target: page
                model: artistsModel
                pageTitle: qsTr("artists")
            }
        },
        State {
            name: "AlbumsListView"
            when: ((orientation === Orientation.Portrait) || (orientation === Orientation.PortraitInverted))
                  && albumView === 1
                  && category === "albums"
            extend: "ArtistsListView"
            PropertyChanges {
                target: page
                model: albumsModel
                pageTitle: (artistname !== "" ? artistname : qsTr("albums"))
            }
        },
        State {
            name: "ArtistsGridView"
            when: ((orientation === Orientation.Portrait) || (orientation === Orientation.PortraitInverted))
                  && artistView === 0
                  && category === "artists"
            PropertyChanges {
                target: contentLoader
                sourceComponent: gridView
            }
            PropertyChanges {
                target: page
                model: artistsModel
                pageTitle: qsTr("artists")
            }
        },
        State {
            name: "AlbumsGridView"
            when: ((orientation === Orientation.Portrait) || (orientation === Orientation.PortraitInverted))
                  && albumView === 0
                  && category === "albums"
            extend: "ArtistsGridView"
            PropertyChanges {
                target: page
                model: albumsModel
                pageTitle: qsTr("albums")
            }
        },
        State {
            name: "ShowView"
            when: ((orientation === Orientation.Landscape) || (orientation === Orientation.LandscapeInverted)) && useShowView
            PropertyChanges {
                target: contentLoader
                sourceComponent: showView
            }
        }
    ]

    Component.onDestruction: {
//        lastIndex = contentLoader.item.currentIndex
//        clearArtistList() //??
    }

    Component.onCompleted: console.debug("hallo")
}
