# -*- coding: utf-8 -*-

from PyQt4.QtGui import QGraphicsItem, QColor, QPainter, QPainterPath
from PyQt4.QtDeclarative import QDeclarativeItem

class Triangle(QDeclarativeItem):
    def __init__(self, parent):
        QDeclarativeItem.__init__(self, parent)
        self.setFlag(QGraphicsItem.ItemHasNoContents, False)
        size = parent.boundingRect()
        self.setHeight(size.height())
        self.setWidth(size.width())

    def paint(self, painter, style, widget):
        painter.setRenderHint(QPainter.Antialiasing, True)

        color = QColor("#999")
        rect = self.boundingRect()

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

        painter.fillPath(path, color)
