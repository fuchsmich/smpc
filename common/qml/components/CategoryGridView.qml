import QtQuick 2.0
import Sailfish.Silica 1.0

SilicaGridView {
    id: gridView
    property string pageTitle: ""
    quickScrollEnabled: jollaQuickscroll
//    model: artistsModel
    cellWidth: Screen.sizeCategory >= Screen.Large ?
                   ((orientation === Orientation.Landscape) || (orientation === Orientation.LandscapeInverted) ?
                        (width / 6) : width / 4) :
                   ((orientation === Orientation.Landscape) || (orientation === Orientation.LandscapeInverted) ?
                        (width/4) : (width / 2))
    cellHeight: cellWidth
    cacheBuffer:0
    property bool scrolling: sectionScroller.scrolling
    populate: Transition {
        NumberAnimation {
            properties: "x"
            from: gridView.width * 2
            duration: populateDuration
        }
    }

    SectionScroller {
        id: sectionScroller
        gridView: gridView
        landscape: false
        sectionPropertyName: "sectionprop"
    }

    ScrollDecorator {
    }

    header: PageHeader {
        title: gridView.pageTitle
        width: parent.width
        height: Theme.itemSizeMedium
    }
}
