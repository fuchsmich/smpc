import QtQuick 2.0

PathView {
    id: showView
    property int itemHeight: height / (1.3)
    property int itemWidth: itemHeight
    model: artistsModel

    SectionScroller {
        pathview: showView
        sectionPropertyName: "sectionprop"
        landscape: true
        z: 120
        interactive: showView.interactive
    }

    cacheItemCount: pathItemCount + 2
    pathItemCount: 12 // width/itemWidth
    delegate: CategoryShowDelegate {
    }
    snapMode: PathView.NoSnap
    preferredHighlightBegin: 0.5
    preferredHighlightEnd: 0.5
    clip: true
    path: Path {
        startX: 0
        startY: showView.height / 2
        // Left out
        PathAttribute {
            name: "z"
            value: 0
        }
        PathAttribute {
            name: "delegateRotation"
            value: 80
        }

        // Left flip (bottom)
        PathLine {
            x: (showView.width / 2) - (showView.itemWidth / 2)
            y: showView.height - showView.itemHeight / 2
        }
        PathAttribute {
            name: "z"
            value: 50
        }
        PathAttribute {
            name: "delegateRotation"
            value: 70
        }
        PathPercent {
            value: 0.45
        }

        // Center (bottom)
        PathLine {
            x: (showView.width / 2)
            y: showView.height - showView.itemHeight / 2
        }
        PathAttribute {
            name: "z"
            value: 100
        }
        PathAttribute {
            name: "delegateRotation"
            value: 0
        }
        PathPercent {
            value: 0.5
        }

        // Right Flip (bottom)
        PathLine {
            x: (showView.width / 2) + (showView.itemWidth / 2)
            y: showView.height - showView.itemHeight / 2
        }
        PathAttribute {
            name: "z"
            value: 50
        }
        PathAttribute {
            name: "delegateRotation"
            value: -70
        }
        PathPercent {
            value: 0.55
        }

        // Right out
        PathLine {
            x: showView.width
            y: showView.height / 2
        }
        PathAttribute {
            name: "z"
            value: 0
        }
        PathAttribute {
            name: "delegateRotation"
            value: -80
        }
        PathPercent {
            value: 1.0
        }
    }
}
