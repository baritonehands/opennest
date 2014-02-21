import QtQuick 1.1

Rectangle {
    id: main
    width: 320
    height: 240

    signal upArrowClicked;

    Column {
        id: column1
        width: 160
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0

        Text {
            id: text1
            x: 67
            y: 99
            text: qsTr("72º")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 48
        }
    }

    Column {
        id: column2
        x: 0
        width: 160
        height: 240
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0

        function createClicked(control) {
            return function() {
                console.log(control.direction)
            }
        }

        Arrow { id: upArrow; objectName: "upArrow"; direction: 1; onClicked: parent.createClicked(upArrow)() }
        Arrow { id: downArrow; objectName: "downArrow"; direction: -1; onClicked: parent.createClicked(downArrow)() }
    }
}
