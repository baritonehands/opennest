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
