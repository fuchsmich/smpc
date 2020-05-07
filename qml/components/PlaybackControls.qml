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
        //checked: mpd_status.shuffle
        checked: ctl.player.playbackStatus.shuffle
        onClicked: ctl.player.setShuffle(!checked)
    }

    IconButton {
        id: prevButton
        icon.source: "image://theme/icon-m-previous"
        anchors.verticalCenter: parent.verticalCenter
        onClicked: ctl.player.previous()
    }

    IconButton {
        id: stopButton
        icon.source: "qrc:images/icon-l-stop.svg"
        icon.sourceSize.width: Theme.iconSizeLarge
        icon.sourceSize.height: Theme.iconSizeLarge
        width: Theme.iconSizeLarge
        height: Theme.iconSizeLarge
        anchors.verticalCenter: parent.verticalCenter
        onClicked: ctl.player.stop()
    }

    IconButton {
        id: playButton
        icon.source: ctl.player.playbackStatus.playbackStatus === 1 ? "image://theme/icon-l-pause" : "image://theme/icon-l-play"
        width: Theme.iconSizeLarge
        height: Theme.iconSizeLarge
        anchors.verticalCenter: parent.verticalCenter
        onClicked: ctl.player.play()
    }

    IconButton {
        id: nextButton
        icon.source: "image://theme/icon-m-next"
        anchors.verticalCenter: parent.verticalCenter
        onClicked: ctl.player.next()
    }

    Switch {
        id: repeatButton
        icon.source: "image://theme/icon-m-repeat"
        automaticCheck: false
        checked: ctl.player.playbackStatus.repeat
        onClicked: ctl.player.setRepeat(!checked)
    }
}
