import QtQuick 1.1

Rectangle {
    id: rectangle1
    height: 60
    color: "#cccccc"
    objectName: "weatherView"
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 0
    anchors.right: parent.right
    anchors.rightMargin: 0
    anchors.left: parent.left
    anchors.leftMargin: 0

    Text {
        id: currentTemp
        color: "#ffffff"
        text: qsTr("...")
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 36
    }

    function updateView(data) {
        currentTemp.text = "%1ºF".arg(data.temp)
    }

    // This is a python Weather object
    property variant weather

    onWeatherChanged: {
        weather.changed.connect(updateView)
    }
}
