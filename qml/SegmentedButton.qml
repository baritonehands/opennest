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
    height: 40

    property bool selected: false
    property string text: "Text"
    property string fontFamily: "Bariol"
    property int lrc: 0

    states: [
        State {
            name: "PRESSED"
            PropertyChanges {
                target: text; color: "#333333"
            }
            PropertyChanges {
                target: bg; color: "#CCCCCC";
            }
            PropertyChanges {
                target: round; color: "#CCCCCC";
            }
        },
        State {
            name: "SELECTED"
            PropertyChanges {
                target: text; color: "#FFFFFF"
            }
            PropertyChanges {
                target: bg; color: "#82CAFA";
            }
            PropertyChanges {
                target: round; color: "#82CAFA";
            }
        },
        State {
            name: "NORMAL"
            PropertyChanges {
                target: text; color: "#FFFFFF"
            }
            PropertyChanges {
                target: bg; color: "transparent";
            }
            PropertyChanges {
                target: round; color: "transparent";
            }
        }
    ]

    onLrcChanged: {
        if(lrc == 0) {
            round.visible = false
            bg.anchors.right = right
            bg.anchors.left = left
        }
        else if(lrc == -1) {
            round.visible = true
            round.anchors.left = left
            bg.anchors.right = right
            bg.anchors.left = round.horizontalCenter
        }
        else if(lrc == 1) {
            round.visible = true
            round.anchors.right = right
            bg.anchors.right = round.horizontalCenter
            bg.anchors.left = left
        }
    }

    onPressed: {
        state = "PRESSED"
    }

    onReleased: {
        state = selected ? "SELECTED" : "NORMAL"
    }

    onSelectedChanged: {
        state = selected ? "SELECTED" : "NORMAL"
    }

    Rectangle {
        id: round
        radius: 10;
        height: parent.height
        width: 20
    }

    Rectangle {
        id: bg
        smooth: true
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
    }

    Text {
        id: text
        text: parent.text
        font.pixelSize: 20
        font.family: fontFamily
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        smooth: true
        anchors.fill: parent
    }
}
