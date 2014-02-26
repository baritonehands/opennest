import QtQuick 1.1

Rectangle {
    height: 60
    color: "#cccccc"
    objectName: "weatherView"
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 0
    anchors.right: parent.right
    anchors.rightMargin: 0
    anchors.left: parent.left
    anchors.leftMargin: 0

    property variant weather
}
