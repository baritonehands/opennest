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
    id: rectangle1
    height: 60
    color: "#cccccc"
    objectName: "weatherView"
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 0
    anchors.right: parent.right
    anchors.rightMargin: 0
    anchors.left: parent.left
    anchors.leftMargin: 0

    Text {
        id: currentTemp
        color: "#ffffff"
        text: qsTr("...")
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 36
        font.family: "Bariol"
    }

    function updateView(data) {
        if(data.weatherAvailable) {
            currentTemp.text = data.tempDisplay
            console.log(data.tempDisplay)
        }
    }

    // This is a python Weather object
    property variant weather

    onWeatherChanged: {
        weather.changed.connect(updateView)
    }
}
