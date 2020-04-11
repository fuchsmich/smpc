import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    allowedOrientations: Orientation.All

    PageHeader {
        id: header
        title: qsTr("Database")
        anchors {
            right: parent.right
            left: parent.left
        }
    }

    SilicaFlickable {
        id: mainFlickable
        anchors {
            fill: parent
            topMargin: header.height
        }
        contentHeight: mainColumn.height
        clip: true

        Column {
            id: mainColumn
            anchors {
                right: parent.right
                left: parent.left
                leftMargin: listPadding
                rightMargin: listPadding
            }

            Label {
                text: qsTr("Albums: %1").arg(dbStatistic.getAlbumCount())
            }
            Label {
                text: qsTr("Blacklisted albums: %1").arg(dbStatistic.getAlbumBlacklistCount())
            }
            Label {
                text: qsTr("Artists: %1").arg(dbStatistic.getArtistCount())
            }
            Label {
                text: qsTr("Images: %1").arg(dbStatistic.getImageCount())
            }
            Label {
                text: qsTr("Filesize: %1 MB").arg(dbStatistic.getDatabaseSize() / 1048576)
            }
            Label {
                text: qsTr("Artist downloads remaining: %1").arg(dbStatistic.getArtistQueueSize())
            }
            Label {
                text: qsTr("Album downloads remaining: %1").arg(dbStatistic.getAlbumQueueSize())
            }
            TextSwitch {
                id: lastfmEnabledSwitch
                text: qsTr("Last.fm Metadata download")
                checked: lastfmEnabled
                onClicked: {
                    if (checked) {
                        newSettingKey(["lastfmEnabled", "1"])
                    } else {
                        newSettingKey(["lastfmEnabled", "0"])
                    }
                }
            }

            ComboBox {
                id: downloadSizeComboBox
                label: qsTr("Download size:")
                currentIndex: downloadSize
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("small")
                    }
                    MenuItem {
                        text: qsTr("medium")
                    }
                    MenuItem {
                        text: qsTr("large")
                    }
                    MenuItem {
                        text: qsTr("extra-large")
                    }
                    MenuItem {
                        text: qsTr("mega")
                    }
                }

                onValueChanged: {
                    newDownloadSize(currentIndex)
                }
            }
            Label {
                id: warningLabel
                width: parent.width
                color: "red"
                text: qsTr("Although the setting \"mega\" will look the best, it will require huge amount of local data cached.")
                wrapMode: "WordWrap"
            }

            Button {
                id: downloadArtistImagesBtn
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Download artist images")
                onClicked: pageStack.push(dialogComponent, {"confirmationRole": 4})
                enabled: dbStatistic.getArtistQueueSize() === 0 && lastfmEnabled
            }
            Button {
                id: downloadAlbumImagesBtn
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Download album images")
                onClicked: pageStack.push(dialogComponent, {"confirmationRole": 5})
                enabled: dbStatistic.getAlbumQueueSize() === 0 && lastfmEnabled
            }
            Button {
                id: clearBlacklistBtn
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Clear blacklisted albums")
                onClicked: pageStack.push(dialogComponent, {"confirmationRole": 0})
                enabled: dbStatistic.getArtistQueueSize() === 0 && dbStatistic.getAlbumQueueSize() === 0
            }
            Button {
                id: clearArtistBtn
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Clear artist images")
                onClicked: pageStack.push(dialogComponent, {"confirmationRole": 1})
                enabled: dbStatistic.getArtistQueueSize() === 0 && dbStatistic.getAlbumQueueSize() === 0
            }
            Button {
                id: clearAlbumBtn
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Clear album images")
                onClicked: pageStack.push(dialogComponent, {"confirmationRole": 2})
            }
            Button {
                id: clearDBBtn
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Clear complete database")
                onClicked: pageStack.push(dialogComponent, {"confirmationRole": 3})
                enabled: dbStatistic.getArtistQueueSize() === 0 && dbStatistic.getAlbumQueueSize() === 0
            }
        }
    }

    Component {
        id: dialogComponent

        Dialog {
            id: confirmationDialog
            allowedOrientations: Orientation.All
            property int confirmationRole
            property string headerText
            property string questionText
            property string acceptText

            DialogHeader {
                id: confirmationHeader
                acceptText: confirmationDialog.acceptText
                title: headerText
            }
            Label {
                id: questionLabel
                text: questionText
                width: parent.width - (2 * listPadding)
                wrapMode: Text.WordWrap
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: confirmationHeader.bottom
                }
            }

            Component.onCompleted: {
                switch (confirmationRole) {
                    // Clear blacklisted albums
                case 0:
                    confirmationDialog.headerText = qsTr("Clear blacklist albums")
                    confirmationDialog.acceptText = confirmationDialog.headerText
                    confirmationDialog.questionText = qsTr("Do you really want to delete all albums which are blacklisted from local database cache? There is no turning back!")
                    break
                    // Clear artists
                case 1:
                    confirmationDialog.headerText = qsTr("Clear artists")
                    confirmationDialog.acceptText = confirmationDialog.headerText
                    confirmationDialog.questionText = qsTr("Do you really want to delete all artists from local database cache? There is no turning back!")
                    break
                    // Clear albums
                case 2:
                    confirmationDialog.headerText = qsTr("Clear albums")
                    confirmationDialog.acceptText = confirmationDialog.headerText
                    confirmationDialog.questionText = qsTr("Do you really want to delete all albums from local database cache? There is no turning back!")
                    break
                    // Clear all
                case 3:
                    confirmationDialog.headerText = qsTr("Clear database")
                    confirmationDialog.acceptText = confirmationDialog.headerText
                    confirmationDialog.questionText = qsTr("Do you really want to delete the complete local database cache? There is no turning back!")
                    break
                case 4:
                    confirmationDialog.headerText = qsTr("Download artists")
                    confirmationDialog.acceptText = confirmationDialog.headerText
                    confirmationDialog.questionText = qsTr(
                                "This will download metadata information for all your artists in your MPD database. "
                                + "This action will run in the background but take some time.")
                    break
                case 5:
                    confirmationDialog.headerText = qsTr("Download albums")
                    confirmationDialog.acceptText = confirmationDialog.headerText
                    confirmationDialog.questionText = qsTr(
                                "This will download metadata information for all your albums in your MPD database. "
                                + "This action will run in the background but take some time.")
                    break
                }
            }
            onAccepted: {
                switch (confirmationRole) {
                case 0:
                    cleanupBlacklisted()
                    break
                case 1:
                    cleanupArtists()
                    break
                case 2:
                    cleanupAlbums()
                    break
                case 3:
                    cleanupDB()
                    break
                case 4:
                    bulkDownloadArtists()
                    break
                case 5:
                    bulkDownloadAlbums()
                    break
                }
            }
        }
    }
}
