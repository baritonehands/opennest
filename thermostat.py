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

import threading, glob, time, math
from PyQt4.QtCore import QObject, pyqtProperty, pyqtSignal

class Thermostat(QObject):
    changed = pyqtSignal(int)

    def __init__(self, parent, units='imperial'):
        QObject.__init__(self, parent)
        self._t = None
        self._temp = (None, None)
        self.units = units
        parent.setProperty('thermostat', self)

        base_dir = '/sys/bus/w1/devices/'
        device_folder = glob.glob(base_dir + '10-*')[0]
        self.device_file = device_folder + '/w1_slave'

    def run(self):
        self._temp = self.read_temp()
        self._t = threading.Timer(1, self.run)
        self._t.start()

    def read_temp_raw(self):
        f = open(self.device_file, 'r')
        lines = f.readlines()
        f.close()
        return lines

    def read_temp(self):
        lines = self.read_temp_raw()
        while lines[0].strip()[-3:] != 'YES':
            time.sleep(0.2)
            lines = self.read_temp_raw()
        equals_pos = lines[1].find('t=')
        if equals_pos != -1:
            temp_string = lines[1][equals_pos+2:]
            temp_c = float(temp_string) / 1000.0
            print '%i C' % temp_c
            if(self.units == 'metric'):
                self.changed.emit(int(temp_c))
                return
            temp_f = temp_c * 9.0 / 5.0 + 32.0
            print '%i F' % temp_f
            self.changed.emit(int(temp_f))

    def start(self):
        self.stop()
        self.run()

    def stop(self):
        if(self._t is not None):
            self._t.cancel()
            self._t = None
