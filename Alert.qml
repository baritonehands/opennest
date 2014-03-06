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

Item {
    width: 320
    height: 240
    visible: false

    signal buttonClicked (int button)

    property string fontFamily: "Bariol"

    function show(txt, buttons) {
        buttonModel.clear()
        for(var i = 0; i < buttons.length; i++) {
            buttonModel.append({ txt: buttons[i] })
        }
        msg.text = txt
        visible = true
    }

    function hide() {
        visible = false
    }

    Rectangle {
        color: "#333333"
        opacity: 0.5
        anchors.fill: parent
    }

    ListModel {
        id: buttonModel
    }

    Rectangle {
        id: inner
        color: "#FFFFFF"
        radius: 20
        width: 280
        height: 200
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Text {
            id: msg
            text: "Your alert message goes here."
            font.pixelSize: 24
            font.family: fontFamily
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.top: parent.top
            anchors.topMargin: 20
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            spacing: 10

            Repeater {
                id: buttons
                model: buttonModel
                Button {
                    text: txt
                    onClicked: {
                        buttonClicked(index)
                        hide()
                    }
                }
            }
        }
    }
}
