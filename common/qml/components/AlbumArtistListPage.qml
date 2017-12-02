import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../../common/qml/components"
//import components 1.0

Page {
    id: artistlistPage
    property int lastIndex
    property int lastOrientation
    allowedOrientations: Orientation.All
    state: "ListView"

    Loader {
        id: contentLoader
        anchors.fill: parent
    }

    Component {
        id: listView
        AlbumArtistListView { }
    }
    Component {
        id: gridView
        AlbumArtistGridView { }
    }
    Component {
        id: showView
        AlbumArtistPathView { }
    }

    states: [
        State {
            name: "ListView"
            when: ((orientation === Orientation.Portrait) || (orientation === Orientation.PortraitInverted)) && artistView === 1
            PropertyChanges {
                target: contentLoader
                sourceComponent: listView
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
        clearArtistList()
    }
}
