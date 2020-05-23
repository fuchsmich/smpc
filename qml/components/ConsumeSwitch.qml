import QtQuick 2.0
import Sailfish.Silica 1.0

Switch {
    icon.source: "qrc:/images/icon-l-consume.svg"
    automaticCheck: false
    checked: ctl.player.playbackStatus.consume
    onClicked: ctl.player.setConsume(!checked)
}
