import QtQuick 2.0
import Sailfish.Silica 1.0
//import "../../../common/qml/components"
import components 1.0

Page {
    id: artistlistPage
    property int lastIndex
    property int lastOrientation
    allowedOrientations: Orientation.All
    state: "ListView"

    Loader {
        id: contentLoader
        anchors.fill: parent
        //        anchors.bottomMargin: quickControlPanel.visibleSize
//        active: false

//        sourceComponent: Component {
//        }
    }

//    onStatusChanged: {
//        if (status === PageStatus.Activating) {
//            if (!orientationTransitionRunning
//                    && orientation != lastOrientation) {
//                gridViewLoader.active = false
//                showViewLoader.active = false
//                if ((orientation === Orientation.Portrait) || (orientation === Orientation.PortraitInverted)) {
//                    if (artistView === 0) {
//                        gridViewLoader.active = true
//                    } else if (artistView === 1) {
//                        listViewLoader.active = true
//                    }
//                } else if ((orientation === Orientation.Landscape) || (orientation === Orientation.LandscapeInverted)) {
//                    if ( useShowView) {
//                        showViewLoader.active = true
//                    } else {
//                        gridViewLoader.active = true
//                    }
//                }
//            }
//        }
//        if (status === PageStatus.Deactivating) {
//            if (typeof (gridViewLoader.item) != undefined
//                    && gridViewLoader.item) {
//                lastIndex = gridViewLoader.item.currentIndex
//            }
//            lastOrientation = orientation
//        } else if (status === PageStatus.Activating
//                   && typeof (gridViewLoader.item) != undefined
//                   && gridViewLoader.item) {
//            gridViewLoader.item.positionViewAtIndex(lastIndex, GridView.Center)
//        }
//    }

//    onOrientationTransitionRunningChanged: {
//        if (!orientationTransitionRunning) {
//            if ((orientation === Orientation.Portrait) || (orientation === Orientation.PortraitInverted)) {
//                if (artistView === 0) {
//                    gridViewLoader.active = true
//                } else if (artistView === 1) {
//                    listViewLoader.active = true
//                }
//            } else if ((orientation === Orientation.Landscape) || (orientation === Orientation.LandscapeInverted)) {
//                if ( useShowView) {
//                    showViewLoader.active = true
//                } else {
//                    gridViewLoader.active = true
//                }
//            }
//        } else {
//            gridViewLoader.active = false
//            showViewLoader.active = false
//            listViewLoader.active = false
//            // Deactivating components
//        }
//    }

    states: [
        State {
            name: "ListView"
            when: ((orientation === Orientation.Portrait) || (orientation === Orientation.PortraitInverted)) && artistView === 0
            PropertyChanges {
                target: contentLoader
                sourceComponent: AlbumArtistListView { }
            }
        },
        State {
            name: "GridView"
            when: ((orientation === Orientation.Portrait) || (orientation === Orientation.PortraitInverted)) && artistView === 1
            PropertyChanges {
                target: contentLoader
                sourceComponent: AlbumArtistGridView { }
            }
        },
        State {
            name: "ShowView"
            when: ((orientation === Orientation.Landscape) || (orientation === Orientation.LandscapeInverted)) && useShowView
            PropertyChanges {
                target: contentLoader
                sourceComponent: AlbumArtistPathView { }
            }
        }
    ]

    Component.onDestruction: {
        clearArtistList()
    }
}
