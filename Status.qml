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
    state: "ON"

    property string text
    property string fontFamily: "Bariol"

    states: [
        State {
            name: "OFF"
            PropertyChanges {
                target: text; color: "#999999"
            }
            PropertyChanges {
                target: icon; color: "#FFFFFF"; border.color: "#999999"
            }
        },
        State {
            name: "ON"
            PropertyChanges {
                target: text; color: "#000000"
            }
            PropertyChanges {
                target: icon; color: "green"; border.color: "#000000"
            }
        }
    ]

    Rectangle {
        id: icon
        width: 12; height: 12; radius: 12
        anchors.verticalCenter: text.verticalCenter
        color: "green"
        border.color: "#000000"
        border.width: 1
        smooth: true
    }

    Text {
        id: text
        text: parent.text
        font.pixelSize: 16
        font.family: fontFamily
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.capitalization: Font.AllUppercase
        anchors.left: icon.right
        anchors.leftMargin: 3
        smooth: true
    }
}
