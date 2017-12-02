import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    height: menuGrid.height
    width: parent.width
    property ListModel menuModel
    signal itemClicked(string ident)

    Grid {
        id: menuGrid

        columns: Screen.sizeCategory
                 >= Screen.Large ? 3 : (orientation === Orientation.Landscape
                                        || orientation
                                        === Orientation.LandscapeInverted) ? 4 : 2
        anchors.horizontalCenter: parent.horizontalCenter
        Repeater {
            model: menuModel
            delegate: Component {
                BackgroundItem {
                    id: gridItem
                    width: Theme.itemSizeHuge
                    height: Theme.itemSizeHuge
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: Theme.paddingSmall
                        color: Theme.rgba(
                                   Theme.highlightBackgroundColor,
                                   Theme.highlightBackgroundOpacity)
                    }
                    Column {
                        anchors.centerIn: parent
                        Image {
                            id: itemIcon
                            source: icon
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Label {
                            id: itemLabel
                            anchors {
                                horizontalCenter: parent.horizontalCenter
                            }
                            font.pixelSize: Theme.fontSizeMedium
                            width: gridItem.width - (2 * Theme.paddingSmall)
                            horizontalAlignment: "AlignHCenter"
                             scale: paintedWidth > width ? (width / paintedWidth) : 1
                       /*     transform: [
                                Scale {
                                    id: scale
                                    xScale: yScale
                                    yScale: itemLabel.width > (gridItem.width - (2 * Theme.paddingSmall)) ? (gridItem.width - (2 * Theme.paddingSmall)) / itemLabel.width : 1
                                },
                                Translate {
                                                x: scale.xScale != 1 ? ((gridItem.width - (2 * Theme.paddingSmall))-itemLabel.width*scale.xScale)/2 : 0 ;
                                                y: scale.yScale != 1 ? ((gridItem.height - (2 * Theme.paddingSmall))-itemLabel.height*scale.yScale)/2 : 0;}
                            ]
*/
                            text: name
                        }
                    }

                    onClicked: {
                        itemClicked(ident)
                    }
                }
            }
        }
    }
}
