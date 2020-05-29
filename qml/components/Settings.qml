import QtQuick 2.0
import Nemo.Configuration 1.0

ConfigurationGroup {
    property alias gui: guiSettings
    path: "/apps/harbour-smpc"
    ConfigurationGroup  {
        id: guiSettings
        path: "/gui"
        property int mainMenuButton: 0
        property int albumViewMode: 0 //albumView
        property int artistViewMode: 0 //artistView
    }
}
