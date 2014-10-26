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

    property string fontFamily: "Bariol"

    Settings {
        id: settings
        onUnitsChanged: {
            weather.weather.units = units
            if(thermostat.thermostat) {
                thermostat.thermostat.units = units
            }
        }
        onFanChanged: {
            if(thermostat.thermostat) {
                thermostat.thermostat.auto = auto
            }
        }
        onModeChanged: {
            if(thermostat.thermostat) {
                thermostat.thermostat.mode = mode
            }
        }
    }

    Item {
        id: item1
        anchors.left: settings.right
        anchors.leftMargin: 0
        anchors.bottom: weather.top
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        width: parent.width

        Item {
            id: statusBars
            height: 30
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 5

            ImageButton {
                width: 30; height: 30
                source: "../icons/settings.png"
                onClicked: settings.toggle()
            }

            Clock {
                anchors.horizontalCenter: parent.horizontalCenter
                fontFamily: main.fontFamily
            }
        }

        Thermostat {
            id: thermostat
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: statusBars.bottom
            anchors.topMargin: 0
            fontFamily: fontFamily
        }
    }

    Weather {
        id: weather
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.left: settings.right
        anchors.leftMargin: 0
        width: parent.width
        fontFamily: parent.fontFamily
        onError: alert.show(text, ['OK'])
    }

    Alert {
        id: alert
        fontFamily: parent.fontFamily
        onButtonClicked: {
            console.log('Clicked ' + button)
        }
    }


}
