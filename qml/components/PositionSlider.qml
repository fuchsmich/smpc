import QtQuick 2.2
import Sailfish.Silica 1.0

Slider {
    stepSize: 1.0
    maximumValue: (ctl.player.playbackStatus.length > 0) ? ctl.player.playbackStatus.length : 1.0
    minimumValue: 0.0
    value: ctl.player.playbackStatus.currentTime
    valueText: formatLength(value)
    label: qsTr("position")
    Label {
        id: lengthTextcomplete
        text: mLengthText
        color: Theme.primaryColor
        font.pixelSize: Theme.fontSizeSmall
        wrapMode: "WordWrap"
        anchors {
            right: parent.right
            rightMargin: Theme.paddingLarge
            bottom: parent.bottom
        }
    }
    onPressedChanged: {
        if (!pressed) {
            ctl.player.seek(value)
            value = Qt.binding(function () {
                return ctl.player.playbackStatus.currentTime
            })
        }
    }
}
