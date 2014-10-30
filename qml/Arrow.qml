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
    id: m
    width: 50 * dp
    height: 50 * dp

    property int direction: 1

    onPressed: {
        m.children[0].color = "#999999"
        m.children[0].borderColor = "#999999"
    }

    onReleased: {
        m.children[0].color = "#CCCCCC"
        m.children[0].borderColor = "#CCCCCC"
    }
}
