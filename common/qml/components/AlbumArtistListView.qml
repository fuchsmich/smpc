import QtQuick 2.0
import Sailfish.Silica 1.0

SilicaListView {
    id: lv
    property string pageTitle: ""
    quickScrollEnabled: jollaQuickscroll
//    model: artistsModel
    clip: true
    populate: Transition {
        NumberAnimation {
            properties: "x"
            from: lv.width * 2
            duration: populateDuration
        }
    }

    SectionScroller {
        listview: lv
        landscape: false
        sectionPropertyName: "sectionprop"
    }
    ScrollDecorator {
    }

    header: PageHeader {
        title: lv.pageTitle
        width: parent.width
        height: Theme.itemSizeMedium
    }

    section {
        property: 'sectionprop'
        delegate: SectionHeader {
            text: section
        }
    }
}
