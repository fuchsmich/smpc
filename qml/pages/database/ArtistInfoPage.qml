import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    id: artistInfoPage
    property string artistname
    PageHeader {
        id: header
        title: artistname
        clip: true
    }
    SilicaFlickable {
        id: textFlickable

        anchors {
            top: header.bottom
            bottom: parent.bottom
            right: parent.right
            left: parent.left
        }
        contentHeight: artistText.implicitHeight

        ScrollDecorator {
        }
        clip: true
        Label {
            id: artistText
            x: Theme.paddingMedium
            y: Theme.paddingMedium
            width: parent.width - 2 * Theme.paddingMedium
            height: implicitHeight
            text: artistInfoText + "\n"
            wrapMode: "WordWrap"
        }
    }
}
