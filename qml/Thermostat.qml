import QtQuick 1.1

Rectangle {
    width: 320 * dp
    height: 110 * dp

    objectName: "thermostatView"
    property string fontFamily: "Bariol"
    property int temp: 72
    property int setTemp: 72
    property variant thermostat

    function updateTemp() {
        temp = thermostat.temp;
        setTemp = thermostat.setTemp;
        heatStatus.state = thermostat.heat ? "ON" : "OFF"
        coolStatus.state = thermostat.cool ? "ON" : "OFF"
        fanStatus.state = thermostat.fan ? "ON" : "OFF"
    }

    onThermostatChanged: {
        thermostat.changed.connect(updateTemp)
    }

    Item {
        width: parent.width * 0.5
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
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.family: fontFamily
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 64 * dp
        }

        Status {
            id: heatStatus
            fontFamily: fontFamily
            text: "Heat"
            anchors.right: coolStatus.left
            anchors.rightMargin: 5 * dp
            anchors.top: txTemp.bottom
            anchors.topMargin: 0
            state: "OFF"
        }

        Status {
            id: coolStatus
            fontFamily: fontFamily
            text: "Cool"
            anchors.horizontalCenter: txTemp.horizontalCenter
            anchors.top: txTemp.bottom
            anchors.topMargin: 0
            state: "ON"
        }

        Status {
            id: fanStatus
            fontFamily: fontFamily
            text: "Fan"
            anchors.left: coolStatus.right
            anchors.leftMargin: 5 * dp
            anchors.top: txTemp.bottom
            anchors.topMargin: 0
            state: "ON"
        }
    }

    Item {
        width: parent.width * 0.5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        Text {
            id: txSetPoint
            width: 70 * dp
            height: font.pixelSize
            text: "%1\u00b0".arg(setTemp)
            anchors.horizontalCenterOffset: -30 * dp
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            font.family: fontFamily
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 40 * dp
        }

        Column {
            width: 50 * dp
            anchors.horizontalCenterOffset: 35 * dp
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: txSetPoint.verticalCenter
            spacing: 10 * dp

            function changeTemp(control) {
                thermostat.setTemp += control.direction
            }

            Arrow { id: upArrow; objectName: "upArrow"; direction: 1; onClicked: parent.changeTemp(upArrow); }
            Arrow { id: downArrow; objectName: "downArrow"; direction: -1; onClicked: parent.changeTemp(downArrow) }
        }
    }
}
