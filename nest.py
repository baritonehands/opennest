#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys, platform

from PyQt4.QtCore import QDateTime, QObject, QUrl, pyqtSignal
from PyQt4.QtGui import QApplication
from PyQt4.QtDeclarative import QDeclarativeView
from triangle import *

def upArrowClicked():
    print 'Testing!'

app = QApplication(sys.argv)

# Create the QML user interface.
view = QDeclarativeView()
view.setSource(QUrl('nest.qml'))
view.setResizeMode(QDeclarativeView.SizeViewToRootObject)

rootObject = view.rootObject()

upArrow = rootObject.findChild(QObject, 'upArrow')
up = Triangle(upArrow)

downArrow = rootObject.findChild(QObject, 'downArrow')
down = Triangle(downArrow)

if(platform.system() == 'Linux'):
    view.showFullScreen()
else:
    view.show()

app.exec_()
