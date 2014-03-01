/*  OpenNest, an open source thermostat
    Copyright (C) 2014  Brian Gregg

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 1.1

Rectangle {
    id: main
    width: 320
    height: 240

    property int temp: 72

    Item {
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
                    width: 80
                    text: qsTr("72°")
                    font.family: "Bariol"
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 48
                }
            }

            Column {
                x: 0
                y: 0
                width: 60
                height: 125
                spacing: 10

                function changeTemp(control) {
                    txTemp.text = qsTr("%1\u00b0".arg(temp += control.direction))
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
