import QtQuick 2.0
import Sailfish.Silica 1.0

Switch {
    icon.source: "image://theme/icon-m-repeat-single?" +
                 (ctl.player.playbackStatus.single === 2 ?
                      Theme.primaryColor : Theme.highlightColor)
    automaticCheck: false
    checked: ctl.player.playbackStatus.single
    onClicked: {
        if (ctl.player.playbackStatus.single < 2) ctl.player.playbackStatus.single++
        else ctl.player.playbackStatus.single = 0
    }
}
