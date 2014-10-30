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
    width: 150 * dp
    height: 40 * dp
    color: "Transparent"
    border.width: 1
    border.color: "#82CAFA"
    radius: 10 * dp
    anchors.horizontalCenter: parent.horizontalCenter

    property variant buttons
    property int selectedIndex: 0

    ListModel {
        id: buttonModel
    }

    Row {
        id: clickable
        anchors.fill: parent

        Repeater {
            id: repeater
            model: buttonModel
            SegmentedButton {
                width: buttonWidth
                text: buttonText
                selected: sel
                lrc: index == 0 ? -1 : (index == buttons.length - 1 ? 1 : 0)
                onClicked: {
                    if(index != selectedIndex) {
                        selectedIndex = index
                        for(var b = 0; b < repeater.count; b++) {
                            repeater.itemAt(b).selected = b == index ? true : false
                        }
                    }
                }
            }
        }
    }

    onButtonsChanged: {
        for(var b in buttons) {
            console.log('Adding button width = %1'.arg(width / buttons.length))
            buttonModel.append({ buttonText: buttons[b], buttonWidth: width / buttons.length, sel: b == selectedIndex })
        }
    }
}
