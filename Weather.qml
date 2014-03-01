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
        id: currentLoc
        text: qsTr("Chicago, IL")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: icon.left
        anchors.rightMargin: 10
        font.pixelSize: 24
        font.family: "Bariol"
        wrapMode: Text.Wrap
    }

    Image {
        id: icon
        objectName: "icon"
        source: "icons/simple_weather_icon_12.png"
        width: 36
        fillMode: Image.PreserveAspectFit
        smooth: true
        anchors.right: currentTemp.left
        anchors.rightMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
    }

    Text {
        id: currentTemp
        text: qsTr("...")
        anchors.right: highLow.left
        anchors.rightMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: 32
        font.family: "Bariol"
    }

    Text {
        id: highLow
        text: qsTr("25\u00b0 F")
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 16
        font.family: "Bariol"
    }

    function updateView(data) {
        if(data.weatherAvailable) {
            currentTemp.text = data.tempDisplay
            currentLoc.text = data.location
            highLow.text = '%1 \u2191\n%1 \u2193'.arg(data.highDisplay, data.lowDisplay)
            icon.source = 'icons/simple_weather_icon_%1.png'.arg(data.conditionIcon)
            console.log(data.tempDisplay)
        }
    }

    // This is a python Weather object
    property variant weather

    onWeatherChanged: {
        weather.changed.connect(updateView)
    }
}
