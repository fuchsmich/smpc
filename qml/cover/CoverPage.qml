import QtQuick 2.2
import Sailfish.Silica 1.0
import "../components"

CoverBackground {
    id: coverpage
    anchors.fill: parent

    function recheckActive() {
        if ((status === Cover.Activating || status === Cover.Active)) {
            coverimg.active = true
        } else {
            coverimg.active = false
        }
    }

    OpacityRampEffect {
        sourceItem: toggleImage
        direction: OpacityRamp.BottomToTop
        visible: (coverimg.sourceprimary != ""
                  || coverimg.sourcesecondary != "")
    }

    Item {
        id: toggleImage
        anchors.fill: parent
        ToggleImage {
            id: coverimg
            anchors.fill: parent
            sourceprimary: coverimageurl
            sourcesecondary: artistimageurl
            fillMode: Image.PreserveAspectCrop
        }
    }

    Rectangle {
        visible: (coverimg.ready)
        anchors.fill: parent
        color: Theme.highlightBackgroundColor
        gradient: Gradient {
            GradientStop {
                position: 0.6
                color: Qt.rgba(0.0, 0.0, 0.0, 0.0)
            }
            GradientStop {
                position: 0.7
                //color: Qt.rgba(0.0, 0.0, 0.0, 0.3)
                color: Theme.rgba(Theme.highlightColor, 0.2)
            }
            GradientStop {
                position: 1.0
                color: Theme.rgba(Theme.highlightColor, 0.5)
                //color: Qt.rgba(0.0,0.0,0.0, 0.8)
            }
        }
    }
    Image {
        id: logo
        visible: ((!coverimg.ready) && (ctl.player.playbackStatus.title == ""))
        source: "qrc:images/pictogram.png"
        anchors.centerIn: parent
        layer.effect: ShaderEffect {
            property color color: Theme.primaryColor

            fragmentShader: "
            varying mediump vec2 qt_TexCoord0;
            uniform highp float qt_Opacity;
            uniform lowp sampler2D source;
            uniform highp vec4 color;
            void main() {
                highp vec4 pixelColor = texture2D(source, qt_TexCoord0);
                gl_FragColor = vec4(mix(pixelColor.rgb/max(pixelColor.a, 0.00390625), color.rgb/max(color.a, 0.00390625), color.a) * pixelColor.a, pixelColor.a) * qt_Opacity;
            }
            "
        }
        layer.enabled: true
        layer.samplerName: "source"
    }

    onStatusChanged: {
        recheckActive()
    }

    Label {
        id: textLabel
        anchors.centerIn: coverpage
        width: coverpage.width - (2 * listPadding)
        height: (coverpage.height / 3) * 2
        wrapMode: "WordWrap"
        elide: Text.ElideRight
        font.pixelSize: Theme.fontSizeLarge
        style: Text.Raised
        styleColor: Theme.secondaryColor
        horizontalAlignment: Text.AlignHCenter
        text: (ctl.player.playbackStatus.title == "" ? "SMPC" : ctl.player.playbackStatus.title)
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-previous-song"
            onTriggered: ctl.player.previous()
        }

        CoverAction {
            iconSource: playbuttoniconsourcecover //"image://theme/icon-cover-pause"
            onTriggered: ctl.player.play()
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-next-song"
            onTriggered: ctl.player.next()
        }
    }
}
