import QtQuick 2.2
import Sailfish.Silica 1.0
import "../../components"

Page {
    id: connectPage
    SilicaListView {
        id: connectListView
        model: serverList
        anchors.fill: parent
        contentWidth: width
        header: PageHeader {
            title: qsTr("Servers")
        }
        PullDownMenu {
            MenuItem {
                text: qsTr("Add server")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("ServerEditPage.qml"), {
                                       "newprofile": true
                                   })
                }
            }
        }
        ScrollDecorator {
        }
        delegate: ListItem {
            contentHeight: Theme.itemSizeSmall
            Image {
                id: image
                x: Theme.paddingLarge
                source: "image://theme/icon-m-computer"
                anchors.verticalCenter: parent.verticalCenter
                opacity: parent.enabled ? 1.0 : 0.4
            }
            Label {
                clip: true
                anchors {
                    left: image.right
                    verticalCenter: parent.verticalCenter
                    leftMargin: listPadding
                    rightMargin: listPadding
                }
                text: name
            }
            onClicked: {
                connectProfile(index)
                pageStack.pop()
            }

            function removeProfileRemorse() {
                remorseAction(qsTr("Removing server profile"), function () {
                    deleteProfile(index)
                }, remorseTimerSecs * 1000)
            }
            menu: ContextMenu {
                id: contextMenu
                MenuItem {
                    id: editItem
                    text: qsTr("Edit server profile")
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("ServerEditPage.qml"), {
                                           "hostname": hostname,
                                           "port": port,
                                           "name": name,
                                           "password": password,
                                           "index": index,
                                           "autoconnect": autoconnect,
                                           "macaddress": macaddress,
                                           "newprofile": false
                                       })
                    }
                }
                MenuItem {
                    id: removeItem
                    text: qsTr("Remove server profile")
                    onClicked: {
                        removeProfileRemorse()
                    }
                }
                MenuItem {
                    id: wakeItem
                    text: qsTr("Wake server")
                    onClicked: {
                        wakeUpServer(index)
                    }
                }
            }
        }
    }
}
