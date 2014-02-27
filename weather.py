#!/usr/bin/env python
# -*- coding: utf-8 -*-

import pywapi, threading, time
from PyQt4.QtCore import QObject, pyqtProperty

class Weather(QObject):
    def __init__(self, parent = None, units='imperial'):
        QObject.__init__(self, parent)
        self.units = units
        parent.setProperty('weather', self)

    def run(self):
        self._current = pywapi.get_weather_from_yahoo('60602', self.units)
        self._t = threading.Timer(30, self.run)
        self._t.start()
        print 'Starting new timer...'

    @pyqtProperty(int)
    def temp(self):
        return int(self._current['condition']['temp'])

    def start(self):
        self.stop()
        self.run()

    def stop(self):
        if(self._t != None):
            self._t.cancel()
            self._t = None
