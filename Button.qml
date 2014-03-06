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

MouseArea {
    state: "NORMAL"

    property string text: "Text"
    property string fontFamily: "Bariol"

    states: [
        State {
            name: "PRESSED"
            PropertyChanges {
                target: text; color: "#EEEEEE"
            }
            PropertyChanges {
                target: bg; color: "#888888";
            }
        },
        State {
            name: "NORMAL"
            PropertyChanges {
                target: text; color: "#FFFFFF"
            }
            PropertyChanges {
                target: bg; color: "#82CAFA";
            }
        }
    ]

    onPressed: {
        state = "PRESSED"
    }

    onReleased: {
        state = "NORMAL"
    }

    Rectangle {
        id: bg
        radius: 10
        anchors.fill: parent
        border.width: 1
        smooth: true
        border.color: "black"
    }

    Text {
        id: text
        text: parent.text
        font.pixelSize: 24
        font.family: fontFamily
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        smooth: true
        anchors.centerIn: parent

        Component.onCompleted: {
            parent.width = width + 30
            parent.height = height + 10
        }
    }
}
