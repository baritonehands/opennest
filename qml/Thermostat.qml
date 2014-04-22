import QtQuick 1.1

Rectangle {
    width: 320
    height: 110

    objectName: "thermostatView"
    property string fontFamily: "Bariol"
    property int temp: 72
    property variant thermostat

    function tempChanged() {
        temp = thermostat.temp;
    }

    onThermostatChanged: {
        thermostat.changed.connect(tempChanged)
    }

    Item {
        width: 160
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        Text {
            id: txTemp
            text: "%1\u00b0".arg(temp)
            horizontalAlignment: Text.AlignHCenter
            anchors.fill: parent
            font.family: fontFamily
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 64
        }
    }

    Item {
        id: item1
        width: 160
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        Text {
            id: txSetPoint
            width: 70
            height: font.pixelSize
            text: "%1\u00b0".arg(temp)
            anchors.horizontalCenterOffset: -20
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignLeft
            font.family: fontFamily
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 40
        }

        Column {
            width: 50
            anchors.horizontalCenterOffset: 30
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: txSetPoint.verticalCenter
            spacing: 10

            function changeTemp(control) {
                temp += control.direction
            }

            Arrow { id: upArrow; objectName: "upArrow"; direction: 1; onClicked: parent.changeTemp(upArrow); }
            Arrow { id: downArrow; objectName: "downArrow"; direction: -1; onClicked: parent.changeTemp(downArrow) }
        }
    }
}
