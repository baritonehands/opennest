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

import pywapi, threading, time, pprint
import json, urllib2
from PyQt4.QtCore import QObject, pyqtProperty, pyqtSignal

class Weather(QObject):
    changed = pyqtSignal(QObject)

    def __init__(self, parent = None, units='imperial'):
        QObject.__init__(self, parent)
        self._t = None
        self._current = dict()
        self.units = units
        parent.setProperty('weather', self)
        self._pp = pprint.PrettyPrinter(indent=4)
        self._loc = json.load(urllib2.urlopen('http://freegeoip.net/json'))
        self._pp.pprint(self._loc)

    def load_weather(self):
        if(self._loc['zipcode'] != ''):
            zip = self._loc['zipcode']
            return pywapi.get_weather_from_yahoo(zip, self.units)

        city = (self._loc['city'], self._loc['region_code'])
        locations = pywapi.get_location_ids('%s, %s' % city)
        self._pp.pprint(locations)
        if(len(locations.items()) > 0):
            return pywapi.get_weather_from_yahoo(locations.items()[0][0], self.units)

    def run(self):
        self._current = self.load_weather()
        self.changed.emit(self)
        self._t = threading.Timer(30, self.run)
        self._t.start()
        self._pp.pprint(self._current)

    @pyqtProperty(bool)
    def weatherAvailable(self):
        return len(self._current.keys()) > 0

    @pyqtProperty(int)
    def temp(self):
        return int(self._current['condition']['temp'])

    def formatTemp(self, temp):
        return u'%i\u00b0 %s' % (temp, self._current['units']['temperature'])

    @pyqtProperty(str)
    def tempDisplay(self):
        return self.formatTemp(self.temp)

    @pyqtProperty(str)
    def highDisplay(self):
        return self.formatTemp(int(self._current['forecasts'][0]['high']))

    @pyqtProperty(str)
    def lowDisplay(self):
        return self.formatTemp(int(self._current['forecasts'][0]['low']))

    @pyqtProperty(str)
    def location(self):
        loc = self._current['location']
        return '%s, %s' % (loc['city'], loc['region'])

    def start(self):
        self.stop()
        self.run()

    def stop(self):
        if(self._t is not None):
            self._t.cancel()
            self._t = None
