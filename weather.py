#!/usr/bin/env python
# -*- coding: utf-8 -*-

import pywapi, threading, time
from PyQt4.QtCore import QObject, pyqtProperty

class Weather(QObject):
    def __init__(self, parent = None, units='imperial'):
        QObject.__init__(self, parent)
        self.units = units
        self._running = False
        parent.setProperty('weather', self)

    def run(self):
        while self._running:
            self._current = pywapi.get_weather_from_yahoo('60602', self.units)
            time.sleep(5)

    @pyqtProperty(int)
    def temp(self):
        return int(self._current['condition']['temp'])

    def start(self):
        self._t = threading.Thread(target=self.run)
        self._running = True
        self._t.start()

    def stop(self):
        self._running = False
