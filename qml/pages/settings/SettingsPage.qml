import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../../common/qml/components"

Page {
    id: settingsPage;
    allowedOrientations: Orientation.All
    SilicaFlickable {
        id: settingsListView
        anchors.fill: parent
        //        anchors.bottomMargin: quickControlPanel.visibleSize
        clip: true
        //        contentWidth: width
        contentHeight: column.height
        Column {
            id: column
            width: settingsPage.width
            PageHeader {
                title: qsTr("settings");
            }
            MenuGrid {
                menuModel: settingsMenuModel
                onItemClicked: parseClickedSettings(ident)
            }
        }
    }


    Component.onCompleted: {
        settingsMenuModel.append({
                                     name:qsTr("server settings"),
                                     ident:"servers",
                                     icon: "image://theme/icon-m-developer-mode"
                                 })
        settingsMenuModel.append({
                                     name:qsTr("database settings"),
                                     ident:"database",
                                     icon: "image://theme/icon-m-developer-mode"
                                 })
        settingsMenuModel.append({
                                     name:qsTr("gui settings"),
                                     ident:"guisettings",
                                     icon: "image://theme/icon-m-developer-mode"
                                 })
        settingsMenuModel.append({
                                     name:qsTr("outputs"),
                                     ident:"outputs",
                                     icon: "image://theme/icon-m-developer-mode"
                                 })
        settingsMenuModel.append({
                                     name:qsTr("update database"),
                                     ident:"updatedb",
                                     icon: "image://theme/icon-m-developer-mode"
                                 })
        settingsMenuModel.append({
                                     name:qsTr("about"),
                                     ident:"about",
                                     icon: "image://theme/icon-m-developer-mode"
                                 })
        // Debug-only
        if(mDebugEnabled) {
            settingsMenuModel.append({"name":qsTr("garbage collection"), "ident":"gc"})
        }
    }

    ListModel {
        id: settingsMenuModel
    }

    function parseClickedSettings(ident)
    {
        switch (ident) {
        case "about" :
            pageStack.push(Qt.resolvedUrl("AboutPage.qml"));
            break;
        case "servers" :
            pageStack.push(Qt.resolvedUrl("ServerListPage.qml"));
            break;
        case "updatedb" :
            updateDB();
            break;
        case "outputs" :
            requestOutputs();
            pageStack.push(Qt.resolvedUrl("OutputsPage.qml"))
            break;
        case "database" :
            pageStack.push(Qt.resolvedUrl("DatabaseSettings.qml"))
            break;
        case "guisettings" :
            pageStack.push(Qt.resolvedUrl("GUISettings.qml"))
            break;
        case "gc" :
            console.debug("Calling garbage collection")
            gc();
            console.debug("Called garbage collection")
            break;
        }
    }
}
