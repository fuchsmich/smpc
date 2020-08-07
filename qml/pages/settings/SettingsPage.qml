import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../components"

Page {
    id: settingsPage
    SilicaListView {
        id: settingsListView
        anchors.fill: parent
        clip: true
        contentWidth: width
        header: PageHeader {
            title: qsTr("Settings")
        }
        model: settingsMenuModel
        delegate: BackgroundItem {
            Label {
                clip: true
                x: Theme.paddingLarge
                anchors {
                    verticalCenter: parent.verticalCenter
                    leftMargin: listPadding
                    rightMargin: listPadding
                }
                text: name
            }
            onClicked: {
                parseClickedSettings(ident)
            }
        }
    }

    Component.onCompleted: {
        settingsMenuModel.append({
                                     "name": qsTr("Server settings"),
                                     "ident": "servers"
                                 })
        settingsMenuModel.append({
                                     "name": qsTr("Database settings"),
                                     "ident": "database"
                                 })
        settingsMenuModel.append({
                                     "name": qsTr("Gui settings"),
                                     "ident": "guisettings"
                                 })
        settingsMenuModel.append({
                                     "name": qsTr("Playback settings"),
                                     "ident": "playback"
                                 })
        settingsMenuModel.append({
                                     "name": qsTr("Outputs"),
                                     "ident": "outputs"
                                 })
        settingsMenuModel.append({
                                     "name": qsTr("Update server database"),
                                     "ident": "updatedb"
                                 })
        settingsMenuModel.append({
                                     "name": qsTr("About"),
                                     "ident": "about"
                                 })
        // Debug-only
        if (mDebugEnabled) {
            settingsMenuModel.append({
                                         "name": qsTr("Garbage collection"),
                                         "ident": "gc"
                                     })
        }
    }

    ListModel {
        id: settingsMenuModel
    }

    function parseClickedSettings(ident) {
        switch (ident) {
        case "about":
            pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            break
        case "servers":
            pageStack.push(Qt.resolvedUrl("ServerListPage.qml"))
            break
        case "updatedb":
            updateDB()
            break
        case "outputs":
            requestOutputs()
            pageStack.push(Qt.resolvedUrl("OutputsPage.qml"))
            break
        case "playback":
            pageStack.push(Qt.resolvedUrl("PlaybackSettings.qml"))
            break
        case "database":
            pageStack.push(Qt.resolvedUrl("DatabaseSettings.qml"))
            break
        case "guisettings":
            pageStack.push(Qt.resolvedUrl("GUISettings.qml"))
            break
        case "gc":
            console.debug("Calling garbage collection")
            gc()
            console.debug("Called garbage collection")
            break
        }
    }
}
