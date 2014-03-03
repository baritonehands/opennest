import QtQuick 1.1

Text {
    font.pixelSize: 16
    font.family: fontFamily
    text: "00:00 am"
    horizontalAlignment: Text.AlignHCenter

    property string fontFamily: "Bariol"

    Timer {
        interval: 500; running: true; repeat: true; triggeredOnStart: true

        property bool on: true;
        onTriggered: {
            var time = Qt.formatTime(new Date(), "h : mm AP").toString()
            time = time.replace(':', on ? "<font color=\"black\">:</font>" : "<font color=\"white\">:</font>")
            parent.text = time
            on = !on
        }
    }
}
