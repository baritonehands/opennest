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
from PyQt4.QtGui import QMessageBox

class Weather(QObject):
    changed = pyqtSignal(QObject)
    error = pyqtSignal(str)

    locationMsg = 'Unable to get location.'

    # Map condition codes to icons. http://developer.yahoo.com/weather/#codes
    icons = ['30','30','30','27','27','26','23','26','21','21',
        '26','22','22','24','24','25','25','28','23','30',
        '09','08','08','30','30','51','06','04','04','07',
        '03','02','01','02','01','29','01','27','27','27',
        '21','25','04','27','24','27']

    def __init__(self, parent = None, units='imperial', test=False):
        QObject.__init__(self, parent)
        self._t = None
        self._test = test
        self._current = dict()
        self._units = units
        parent.setProperty('weather', self)
        self._pp = pprint.PrettyPrinter(indent=4)

    def location(self):
        if(not hasattr(self, '_loc')):
            try:
                #raise urllib2.URLError('Testing')
                loc = json.load(urllib2.urlopen('http://freegeoip.net/json', timeout=20))
                #self._pp.pprint(self._loc)
                if(loc['zipcode'] != ''):
                    self._loc = loc['zipcode']
                else:
                    city = (loc['city'], loc['region_code'])
                    locations = pywapi.get_location_ids('%s, %s' % city)
                    #self._pp.pprint(locations)
                    if(len(locations.items()) == 0):
                        self.error.emit(self.locationMsg)
                        self._loc = ''
                    self._loc = locations.items()[0][0]
            except urllib2.URLError:
                self.error.emit(self.locationMsg)
                self._loc = ''
        return self._loc

    def run(self):
        try:
            weather = pywapi.get_weather_from_yahoo(self.location(), self.units)
            if 'error' not in weather:
                self._current = weather
                self.changed.emit(self)
            else:
                self.error.emit(weather['error'])
        except:
            self.error.emit('Could not retrieve weather.')
        self._t = threading.Timer(30, self.run)
        self._t.daemon = True
        self._t.start()
        if self._test: self._pp.pprint(self._current)

    @pyqtProperty(bool)
    def weatherAvailable(self):
        return len(self._current.keys()) > 0

    @pyqtProperty(str)
    def units(self):
        return self._units

    @units.setter
    def units(self, value):
        self._units = value
        self.stop()
        self.start()

    @pyqtProperty(int)
    def temp(self):
        return int(self._current['condition']['temp'])

    def formatTemp(self, temp):
        return u'%i\u00b0' % temp #, self._current['units']['temperature'])

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
    def locationDisplay(self):
        loc = self._current['location']
        return '%s, %s' % (loc['city'], loc['region'])

    @pyqtProperty(str)
    def conditionIcon(self):
        return self.icons[int(self._current['condition']['code'])]

    def start(self):
        self.stop()
        self.run()

    def stop(self):
        if(self._t is not None):
            self._t.cancel()
            self._t = None

if __name__ == "__main__":
    from PyQt4.QtCore import QCoreApplication
    import sys, pdb, signal

    signal.signal(signal.SIGINT, signal.SIG_DFL)

    app = QCoreApplication(sys.argv)

    # Testing the thermostat on the console
    t = Weather(parent=app, test=True)
    t.start()

    app.exec_()

    print 'Stopping...'
    t.stop()
