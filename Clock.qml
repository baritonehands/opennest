import QtQuick 1.1

Text {
    font.pixelSize: 16
    font.family: fontFamily
    text: "00:00 am"
    horizontalAlignment: Text.AlignHCenter

    property string fontFamily: "Bariol"

    Timer {
        interval: 1000; running: true; repeat: true; triggeredOnStart: true

        onTriggered: {
            parent.text = Qt.formatTime(new Date(), "h : mm AP")
        }
    }
}
