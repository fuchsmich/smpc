import QtQuick 2.2
import Sailfish.Silica 1.0

Slider {
    id: volumeSlider

    //property bool volumeChanging: false
    stepSize: 1
    maximumValue: 100
    minimumValue: 0
    // value: ctl.player.playbackstatus.volume
    valueText: value + "%"
    label: qsTr("Volume")
    onPressedChanged: {
        if (!pressed) {
            //    volumeChanging = false
            ctl.player.setVolume(value)
            //            value = Qt.binding(function () {
            //                return ctl.player.playbackStatus.volume
            //            })
        } else {

            //      volumeChanging = true
        }
    }
    onValueChanged: {
        if (pressed)
            ctl.player.setVolume(value)
    }
    Binding {
        target: volumeSlider
        property: "value"
        value: ctl.player.playbackStatus.volume
    }
}
