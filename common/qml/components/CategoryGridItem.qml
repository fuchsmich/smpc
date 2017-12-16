import QtQuick 2.1
import Sailfish.Silica 1.0

ListItem {
    id: listItem
    //    property string destination
    property string albumTitle: ""
    property string artist: ""
    property alias labelText: label.text
    property string imageUrl: ""
    property bool scrolling: false

    layer.enabled: true
    layer.effect: ShaderEffect {
        blending: highlighted
    }

    width: GridView.view.cellWidth
    height: width
    contentHeight: width

    Rectangle {
        anchors.fill: parent
        anchors.margins: Theme.paddingSmall
        color: Theme.rgba(Theme.highlightBackgroundColor, 0.2)
        Image {
            id: image
            anchors.fill: parent
            source: listItem.scrolling ? "" : imageUrl
            cache: false
            asynchronous: true
            fillMode: Image.PreserveAspectCrop
        }
        Rectangle {
            id: gradientRect
            visible: true
            anchors {
                bottom: parent.bottom
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }
            width: parent.width

            gradient: Gradient {
                GradientStop {
                    position: 0.5
                    color: Qt.rgba(0.0, 0.0, 0.0, 0.0)
                }
                GradientStop {
                    position: 1.0
                    color: Qt.rgba(0.0, 0.0, 0.0, 0.8)
                }
            }
        }
        Label {
            id: label
            anchors {
                bottom: image.bottom
                horizontalCenter: image.horizontalCenter
            }
            height: parent.height * 0.5
            width: parent.width
            wrapMode: "WordWrap"
            elide: Text.ElideRight
            font.pixelSize: Theme.fontSizeSmall
            style: Text.Raised
            styleColor: Theme.secondaryColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
        }
    }

//    states: [
//        State {
//            name: "artists"
//            PropertyChanges {
//                target: listItem
////                menu: artistContextMenu
//            }
//            PropertyChanges {
//                target: label
//                text: artist === "" ? qsTr("No Artist Tag") : artist
//            }
//        },
//        State {
//            name: "albums"
//            PropertyChanges {
//                target: listItem
////                menu: albumContextMenu
//            }
//            PropertyChanges {
//                target: label
//                text: albumTitle === "" ? qsTr("No Album Tag") : albumTitle
//            }
//        }
//    ]
}
