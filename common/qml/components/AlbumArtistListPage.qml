import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../../common/qml/components"
//import components 1.0

Page {
    id: page
    property string category: "artists"
    property var model
    property string pageTitle: ""
    property int lastIndex
    property int lastOrientation

    onModelChanged: console.log(model.count)

    allowedOrientations: Orientation.All

    state: "ListView"

    Loader {
        id: contentLoader
        anchors.fill: parent
    }

    Component {
        id: listViewComp
        AlbumArtistListView {
            id: listView
            model: page.model
            pageTitle: page.pageTitle
            delegate: AlbumArtistListDelegate {
                state: page.category
                albumTitle: (typeof model.title !== "undefined" ? model.title : "")
                artist: model.artist
                imageUrl: (typeof model.coverURL !== "undefined" ? model.coverURL :
                                                                   typeof model.imageURL !== "undefined"? model.imageURL : "")
                onClicked: listView.currentIndex = model.index
            }
        }
    }
    Component {
        id: gridView
        AlbumArtistGridView {
            model: page.model
        }
    }
    Component {
        id: showView
        AlbumArtistPathView {
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
                  && artistView === 1
                  && category === "albums"
            extend: "ArtistsListView"
            PropertyChanges {
                target: page
                model: albumsModel
                pageTitle: qsTr("albums")
            }
        },
        State {
            name: "GridView"
            when: ((orientation === Orientation.Portrait) || (orientation === Orientation.PortraitInverted)) && artistView === 0
            PropertyChanges {
                target: contentLoader
                sourceComponent: gridView
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
        lastIndex = contentLoader.item.currentIndex
//        clearArtistList() //??
    }
}
