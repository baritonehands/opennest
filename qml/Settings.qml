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
    id: settings
    width: parent.width * 0.5
    height: parent.height
    visible: true
    color: "#666666"
    state: "CLOSED"

    property string fontFamily: "Bariol"
    signal unitsChanged(string units)
    signal fanChanged(bool auto)
    signal modeChanged(int mode)

    Column {
        spacing: 10 * dp
        width: parent.width - 20 * dp
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Column {
            spacing: 5 * dp
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                font.family: fontFamily
                font.pixelSize: 16 * dp
                text: "Mode:"
                color: "white"
            }

            SegmentedControl {
                buttons: ["Off", "Heat", "Cool"]
                selectedIndex: 1
                onSelectedIndexChanged: {
                    modeChanged(selectedIndex == 0 ? 0 : (selectedIndex == 1 ? 1 : -1))
                }
            }
        }

        Column {
            spacing: 5 * dp
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                font.family: fontFamily
                font.pixelSize: 16 * dp
                text: "Fan:"
                color: "white"
            }

            SegmentedControl {
                buttons: ["Auto", "On"]
                onSelectedIndexChanged: {
                    fanChanged(selectedIndex == 0 ? true : false)
                }
            }
        }

        Column {
            spacing: 5 * dp
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                font.family: fontFamily
                font.pixelSize: 16 * dp
                text: "Units:"
                color: "white"
            }

            SegmentedControl {
                buttons: ["\u00b0 F", "\u00b0 C"]
                onSelectedIndexChanged: {
                    unitsChanged(selectedIndex == 0 ? 'imperial' : 'metric')
                }
            }
        }
    }

    states: [
        State {
            name: "OPEN"
            PropertyChanges {
                target: settings; x: 0
            }
        },
        State {
            name: "CLOSED"
            PropertyChanges {
                target: settings; x: -width
            }
            PropertyChanges {
                target: settings; visible: false;
            }
        }
    ]

    transitions: [
        Transition {
            to: "OPEN"
            from: "CLOSED"
            NumberAnimation { target: settings; property: "x"; easing.type: Easing.InQuad; duration: 300  }
        },
        Transition {
            to: "CLOSED"
            from: "OPEN"
            NumberAnimation { target: settings; property: "x"; easing.type: Easing.OutQuad; duration: 300 }
            PropertyAnimation { target: settings; property: "visible"; easing.type: Easing.OutQuad; duration: 300 }
        }
    ]

    function show() {
        state = "OPEN"
        visible = true
    }

    function hide() {
        state = "CLOSED"
    }

    function toggle() {
        if(visible) {
            hide()
        }
        else {
            show()
        }
    }
}
