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
    color: "#82CAFA"
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
        anchors.leftMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        verticalAlignment: Text.AlignBottom
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: 32
        font.family: "Bariol"
    }
    Text {
        id: high
        color: "#ffffff"
        text: qsTr("25\u00b0 F")
        anchors.right: currentLoc.left
        anchors.rightMargin: 10
        anchors.bottom: low.top
        anchors.bottomMargin: 0
        verticalAlignment: Text.AlignBottom
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 16
        font.family: "Bariol"
    }
    Text {
        id: low
        color: "#ffffff"
        text: qsTr("8\u00b0 F")
        anchors.right: currentLoc.left
        anchors.rightMargin: 10
        anchors.bottom: currentTemp.bottom
        anchors.bottomMargin: 0
        verticalAlignment: Text.AlignBottom
        horizontalAlignment: Text.Right
        font.pixelSize: 16
        font.family: "Bariol"
    }

    Text {
        id: currentLoc
        color: "#ffffff"
        text: qsTr("Text")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        font.pixelSize: 24
        font.family: "Bariol"
    }

    function updateView(data) {
        if(data.weatherAvailable) {
            currentTemp.text = data.tempDisplay
            currentLoc.text = data.location
            high.text = data.highDisplay
            low.text = data.lowDisplay
            console.log(data.tempDisplay)
        }
    }

    // This is a python Weather object
    property variant weather

    onWeatherChanged: {
        weather.changed.connect(updateView)
    }
}
