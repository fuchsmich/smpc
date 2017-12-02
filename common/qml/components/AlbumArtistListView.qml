import QtQuick 2.0
import Sailfish.Silica 1.0

SilicaListView {
    id: artistListView
    quickScrollEnabled: jollaQuickscroll
    model: artistsModel
    clip: true
    populate: Transition {
        NumberAnimation {
            properties: "x"
            from: artistListView.width * 2
            duration: populateDuration
        }
    }

    SectionScroller {
        listview: artistListView
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

    delegate: ArtistListDelegate {
    }

    section {
        property: 'sectionprop'
        delegate: SectionHeader {
            text: section
        }
    }
}
