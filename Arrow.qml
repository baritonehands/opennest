import QtQuick 1.1

Rectangle {
    width: 80
    height: 80

    property int direction: 1
    signal clicked;

    Component.onCompleted: {
        m.clicked.connect(clicked)
    }

    MouseArea {
        id: m
        anchors.fill: parent

        PathView {
            anchors.fill: parent
            path: Path {
                startX: 0; startY: parent.height
                PathLine { x: parent.width / 2; y: 0 }
                PathLine { x: parent.width; y: parent.height }
            }
        }
    }
}
