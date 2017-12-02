import QtQuick 2.0
import Sailfish.Silica 1.0

SilicaListView {
    id: listView
    property string title: ""
    quickScrollEnabled: jollaQuickscroll
//    model: artistsModel
    clip: true
    populate: Transition {
        NumberAnimation {
            properties: "x"
            from: listView.width * 2
            duration: populateDuration
        }
    }

    SectionScroller {
        listview: listView
        landscape: false
        sectionPropertyName: "sectionprop"
    }
    ScrollDecorator {
    }

    header: PageHeader {
        title: listView.title
        width: parent.width
        height: Theme.itemSizeMedium
    }

    delegate: ArtistListDelegate {
    }

    section {
        property: 'sectionprop'
        delegate: SectionHeader {
            text: section
        }
    }
}
