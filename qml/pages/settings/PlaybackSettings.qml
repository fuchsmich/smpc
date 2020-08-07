import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    id: playbacksettingsPage
    PageHeader {
        id: header
        title: qsTr("Playback settings")
        anchors {
            right: parent.right
            left: parent.left
        }
    }

    SilicaFlickable {
        id: mainFlickable
        anchors.fill: parent
        contentHeight: mainColumn.height
        anchors.topMargin: header.height

        VerticalScrollDecorator {
        }

        Column {
            id: mainColumn
            anchors {
                left: parent.left
                right: parent.right
            }
            TextSwitch {
                id: shuffleSwitch
                text: qsTr("Shuffle")
                description: qsTr("Play in random order")
                automaticCheck: false
                checked: ctl.player.playbackStatus.shuffle
                onClicked: ctl.player.setShuffle(!checked)
            }
            TextSwitch {
                id: repeatSwitch
                text: qsTr("Repeat")
                automaticCheck: false
                description: qsTr("Play in never ending loop")
                checked: ctl.player.playbackStatus.repeat
                onClicked: ctl.player.setRepeat(!checked)
            }
            TextSwitch {
                id: consumeSwitch
                automaticCheck: false
                text: qsTr("Consume track")
                checked: ctl.player.playbackStatus.consume
                description: qsTr("Each song played is removed from playlist")
                onClicked: ctl.player.setConsume(!checked)
            }
            TextSwitch {
                id: singleSwitch
                automaticCheck: false
                text: qsTr("Single playback")
                checked: ctl.player.playbackStatus.single
                description: qsTr("Playback is stopped after current song, or song is repeated if the ‘repeat’ mode is enabled")
                onClicked: {
                    if (ctl.player.playbackStatus.single < 2)
                        ctl.player.setSingle(
                                    ctl.player.playbackStatus.single + 1)
                    else
                        ctl.player.setSingle(0)
                }
            }
        }
    }
}
