#!/usr/bin/env python
# -*- coding: utf-8 -*-

import pywapi, threading, time, pprint
import json, urllib2
from PyQt4.QtCore import QObject, pyqtProperty, pyqtSignal

class Weather(QObject):
    changed = pyqtSignal(QObject)

    def __init__(self, parent = None, units='imperial'):
        QObject.__init__(self, parent)
        self._t = None
        self.units = units
        parent.setProperty('weather', self)
        self._pp = pprint.PrettyPrinter(indent=4)
        loc = json.load(urllib2.urlopen('http://freegeoip.net/json'))
        self.zip = loc['zipcode']

    def run(self):
        self._current = pywapi.get_weather_from_yahoo(self.zip, self.units)
        self.changed.emit(self)
        self._t = threading.Timer(30, self.run)
        self._t.start()
        #self._pp.pprint(self._current)

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
