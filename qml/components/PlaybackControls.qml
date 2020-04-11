import QtQuick 2.2
import Sailfish.Silica 1.0

Row {
    anchors.horizontalCenter: parent.horizontalCenter
    height: shuffleButton.height

    property alias shuffleButton: shuffleButton
    property alias repeatButton: repeatButton

    Switch {
        id: shuffleButton
        icon.source: "image://theme/icon-m-shuffle"
        automaticCheck: false
        checked: mpd_status.shuffle
        onClicked: setShuffle(!checked)
    }

    IconButton {
        id: prevButton
        icon.source: "image://theme/icon-m-previous"
        anchors.verticalCenter: parent.verticalCenter
        onClicked: prev()
    }

    IconButton {
        id: stopButton
        icon.source: "qrc:images/icon-l-stop.svg"
        icon.sourceSize.width: Theme.iconSizeLarge
        icon.sourceSize.height: Theme.iconSizeLarge
        width: Theme.iconSizeLarge
        height: Theme.iconSizeLarge
        anchors.verticalCenter: parent.verticalCenter
        onClicked: stop()
    }

    IconButton {
        id: playButton
        icon.source: mpd_status.playbackStatus === 1 ? "image://theme/icon-l-pause" : "image://theme/icon-l-play"
        width: Theme.iconSizeLarge
        height: Theme.iconSizeLarge
        anchors.verticalCenter: parent.verticalCenter
        onClicked: play()
    }

    IconButton {
        id: nextButton
        icon.source: "image://theme/icon-m-next"
        anchors.verticalCenter: parent.verticalCenter
        onClicked: next()
    }

    Switch {
        id: repeatButton
        icon.source: "image://theme/icon-m-repeat"
        automaticCheck: false
        checked: mpd_status.repeat
        onClicked: setRepeat(!checked)
    }
}
