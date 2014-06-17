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

    property string source

    states: [
        State {
            name: "PRESSED"
            PropertyChanges {
                target: img; opacity: 1.0
            }
        },
        State {
            name: "NORMAL"
            PropertyChanges {
                target: img; opacity: 0.50
            }
        }
    ]

    onPressed: {
        state = "PRESSED"
    }

    onReleased: {
        state = "NORMAL"
    }

    Image {
        id: img
        anchors.fill: parent
        smooth: true
        source: parent.source
    }
}
