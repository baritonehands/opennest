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

from PyQt4.QtCore import pyqtProperty
from PyQt4.QtGui import QGraphicsItem, QColor, QPainter, QPainterPath, QPen
from PyQt4.QtDeclarative import QDeclarativeItem

class Triangle(QDeclarativeItem):
    def __init__(self, parent):
        QDeclarativeItem.__init__(self, parent)
        self.setFlag(QGraphicsItem.ItemHasNoContents, False)
        size = parent.boundingRect()
        self.setHeight(size.height())
        self.setWidth(size.width())
        self.color = QColor("#CCCCCC")
        self.borderColor = QColor("#82CAFA")

    @pyqtProperty(QColor)
    def color(self):
        return self._color

    @color.setter
    def color(self, value):
        self._color = value
        self.update()

    @pyqtProperty(QColor)
    def borderColor(self):
        return self._borderColor

    @borderColor.setter
    def borderColor(self, value):
        self._borderColor = value
        self.update()

    def paint(self, painter, style, widget):
        painter.setRenderHint(QPainter.Antialiasing, True)

        rect = self.boundingRect()
        pen = QPen(self.borderColor)
        pen.setWidthF(3)

        path = QPainterPath()
        if(self.parentItem().property('direction') == 1):
            path.moveTo(0, rect.height())
            path.lineTo(rect.width() / 2, 0)
            path.lineTo(rect.width(), rect.height())
            path.lineTo(0, rect.height())
        else:
            path.moveTo(0, 0)
            path.lineTo(rect.width() / 2, rect.height())
            path.lineTo(rect.width(), 0)
            path.lineTo(0, 0)

        painter.fillPath(path, self.color)
        painter.strokePath(path, pen)
