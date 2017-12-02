import QtQuick 2.0
import Sailfish.Silica 1.0

SilicaGridView {
    id: artistGridView
    quickScrollEnabled: jollaQuickscroll
    model: artistsModel
    cellWidth: Screen.sizeCategory >= Screen.Large ? ((orientation === Orientation.Landscape) || (orientation === Orientation.LandscapeInverted)
                                                      ? (width / 6) : width / 4) :
                                                     ((orientation === Orientation.Landscape) || (orientation === Orientation.LandscapeInverted) ? (width/4) : (width / 2))
    cellHeight: cellWidth
    cacheBuffer:0
    property bool scrolling: sectionScroller.scrolling
    populate: Transition {
        NumberAnimation {
            properties: "x"
            from: artistGridView.width * 2
            duration: populateDuration
        }
    }

    SectionScroller {
        id: sectionScroller
        gridView: artistGridView
        landscape: false
        sectionPropertyName: "sectionprop"
    }
    ScrollDecorator {
    }

    header: PageHeader {
        title: qsTr("artists")
        width: parent.width
        height: Theme.itemSizeMedium
    }

    delegate: ArtistDelegate {

        artist: model.artist
        imgSource: (artistGridView.scrolling) ? "" : model.imageURL
        onClicked: {
            artistGridView.currentIndex = index
            artistClicked(artist)
            pageStack.push(Qt.resolvedUrl("AlbumListPage.qml"), {
                               artistname: artistname
                           })
        }
    }
}
