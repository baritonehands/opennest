#!/usr/bin/env python
# -*- coding: utf-8 -*-
#    OpenNest, an open source thermostat
#    Copyright (C) 2014  Brian Gregg

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

import sys, platform, getopt

from PyQt4.QtCore import QDateTime, QObject, QUrl, pyqtSignal
from PyQt4.QtGui import QApplication, QGraphicsColorizeEffect, QColor
from PyQt4.QtDeclarative import QDeclarativeView
from triangle import *
from weather import *

def upArrowClicked():
    print 'Testing!'

app = QApplication(sys.argv)

# Create the QML user interface.
view = QDeclarativeView()
view.setSource(QUrl('qml/nest.qml'))
view.setResizeMode(QDeclarativeView.SizeViewToRootObject)

rootObject = view.rootObject()

upArrow = rootObject.findChild(QObject, 'upArrow')
up = Triangle(upArrow)

downArrow = rootObject.findChild(QObject, 'downArrow')
down = Triangle(downArrow)

weatherView = rootObject.findChild(QObject, 'weatherView')
weather = Weather(weatherView)
weather.start()

try:
    opts, args = getopt.getopt(sys.argv[1:], "f")
except getopt.GetoptError as err:
    # print help information and exit:
    print str(err) # will print something like "option -a not recognized"
    sys.exit(2)
fullscreen = False
for o, a in opts:
    if o == "-f":
        fullscreen = True
    else:
        assert False, "unhandled option"

thermostat = None
try:
    from thermostat import *
    thermoView = rootObject.findChild(QObject, 'thermostatView')
    thermostat = Thermostat(thermoView)
    thermostat.start()
except: pass

if(fullscreen):
    view.showFullScreen()
else:
    view.show()

app.exec_()

weather.stop()
if thermostat is not None:
    thermostat.stop()

