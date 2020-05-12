import QtQuick 2.2
import Sailfish.Silica 1.0
import "../../components"

Page {
    id: filePage
    allowedOrientations: Orientation.All
    property string filepath
    property var listmodel
    property int lastContentPosY: 0
    SilicaListView {
        id: fileListView
        model: listmodel
        quickScrollEnabled: jollaQuickscroll
        highlightFollowsCurrentItem: true
        SpeedScroller {
            id: scroller
            listview: fileListView
            scrollenabled: fastscrollenabled
        }
        clip: true
        ScrollDecorator {
        }

        anchors {
            fill: parent
            //                bottomMargin: quickControlPanel.visibleSize
        }
        contentWidth: width
        header: PageHeader {
            title: qsTr("Filebrowser") //(filepath===""? "Files:" : filepath)
        }
        PullDownMenu {
            MenuItem {
                text: qsTr("Home")
                onClicked: {
                    pageStack.clear()
                    pageStack.push(initialPage)
                }
            }
            MenuItem {
                text: qsTr("Add folder")
                onClicked: {
                    ctl.player.playlist.addFiles(filepath)
                }
            }
            MenuItem {
                text: qsTr("Play folder")
                onClicked: {
                    //FIXME does it work for paths??
                    ctl.player.playlist.playTrack(filepath)
                }
            }
        }
        delegate: FileDelegate {
        }
    }

    onStatusChanged: {
        // Restore scroll position
        if (status === PageStatus.Activating && lastContentPosY) {
            fileListView.cancelFlick()
            fileListView.positionViewAtIndex(lastContentPosY, ListView.Center)
        }
    }

    Component.onDestruction: {
        fastscrollenabled = false
        popfilemodelstack()
    }
}
