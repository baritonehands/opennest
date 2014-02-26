import QtQuick 1.1

Rectangle {
    id: main
    width: 320
    height: 240

    property int temp: 72

    Rectangle {
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: weather.top
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        Row {
            width: 154
            height: 125
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter
            Column {
                x: 0
                y: 0
                height: 125

                Text {
                    id: txTemp
                    height: 125
                    text: qsTr("72º")
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 48
                }
            }

            Column {
                x: 0
                y: 0
                width: 60
                height: 125
                spacing: 5

                function changeTemp(control) {
                    txTemp.text = qsTr("%1º".arg(temp += control.direction))
                    console.log(control.direction);
                    console.log(weather.weather.temp)
                }

                Arrow { id: upArrow; objectName: "upArrow"; direction: 1; onClicked: parent.changeTemp(upArrow); }
                Arrow { id: downArrow; objectName: "downArrow"; direction: -1; onClicked: parent.changeTemp(downArrow) }
            }
        }
    }

    Weather {
        id: weather
    }
}
