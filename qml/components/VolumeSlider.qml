import QtQuick 2.2
import Sailfish.Silica 1.0

Slider {
    stepSize: 1
    maximumValue: 100
    minimumValue: 0
    value: ctl.player.playbackStatus.volume
    valueText: value + "%"
    label: qsTr("Volume")
    onPressedChanged: {
        if (!pressed) {
            volumeChanging = false
            ctl.player.playbackStatus.volume = value
            value = Qt.binding(function () {
                return ctl.player.playbackStatus.volume
            })
        } else {
            volumeChanging = true
        }
    }
    onValueChanged: {
        if (pressed) ctl.player.playbackStatus.volume = value
    }
}
