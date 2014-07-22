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
import RPi.GPIO as GPIO

class Thermostat(QObject):
    changed = pyqtSignal(QObject)
    HEAT = 17
    COOL = 18
    FAN = 22
    
    HIST = 10

    def __init__(self, parent=None, units='imperial', test=False):
        QObject.__init__(self, parent)
        self._t = None
        self._test = test
        self._temp = (0, 0)
        self._history = []
        self._hilo = [40.0 * 5.0 / 9.0, 20]
        self._state = [False, False, False]
        self._units = units
        self._auto = True
        if parent is not None:
            parent.setProperty('thermostat', self)
            
        self.changed.connect(self.onChange)

        base_dir = '/sys/bus/w1/devices/'
        device_folder = glob.glob(base_dir + '10-*')[0]
        self.device_file = device_folder + '/w1_slave'
        
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(self.HEAT, GPIO.OUT)
        GPIO.output(self.HEAT, self._state[0])
        GPIO.setup(self.COOL, GPIO.OUT)
        GPIO.output(self.COOL, self._state[1])
        GPIO.setup(self.FAN, GPIO.OUT)
        GPIO.output(self.FAN, self._state[2])
    
    @pyqtProperty(bool)
    def heat(self):
        return self._state[0]
    
    @heat.setter
    def heat(self, value):
        self._state[0] = value
        GPIO.output(self.HEAT, value)
    
    @pyqtProperty(bool)
    def cool(self):
        return self._state[1]
    
    @cool.setter
    def cool(self, value):
        self._state[1] = value
        GPIO.output(self.COOL, value)
    
    @pyqtProperty(bool)
    def fan(self):
        return self._state[2]
    
    @fan.setter
    def fan(self, value):
        self._state[2] = value
        GPIO.output(self.FAN, value)
    
    @pyqtProperty(bool)
    def auto(self):
        return self._auto
    
    @auto.setter
    def auto(self, value):
        self._auto = value
        self.changed.emit(self)
        
    @pyqtProperty(str)
    def units(self):
        return self._units

    @units.setter
    def units(self, value):
        self._units = value
        if value == 'metric':
            self._hilo[0] = round(self._hilo[0])
            self._hilo[1] = round(self._hilo[1])
        else:
            self._hilo[0] = self.convertFromDisp(round(self.convertToDisp(self._hilo[0])))
            self._hilo[1] = self.convertFromDisp(round(self.convertToDisp(self._hilo[1])))
        self.stop()
        self.start()
    
    @pyqtProperty(int)
    def temp(self):
        if(self.units == 'imperial'): return int(self._temp[1])
        return int(self._temp[0])
        
    @pyqtProperty(int)
    def setTemp(self):
        (hi, low) = self._hilo
        mid = (hi + low) / 2.0;
        value = self._temp[0]
        if value >= mid:
            return self.convertToDisp(hi)
        elif value < mid:
            return self.convertToDisp(low)
    
    @setTemp.setter
    def setTemp(self, value):
        (hi, low) = self._hilo
        mid = (hi + low) / 2.0;
        if value >= mid and value >= low:
            self._hilo[0] = self.convertFromDisp(value)
            if(self._hilo[0] < self._hilo[1]): self._hilo[1] = self._hilo[0]
            self.changed.emit(self)
        elif value < mid and value <= hi:
            self._hilo[1] = self.convertFromDisp(value)
            if(self._hilo[1] > self._hilo[0]): self._hilo[0] = self._hilo[1]
            self.changed.emit(self)
    
    def convertFromDisp(self, t):
        if self.units == 'imperial':
            return (t - 32.0) * 5.0 / 9.0
        return t
    
    def convertToDisp(self, t):
        if self.units == 'imperial':
            return t * 9.0 / 5.0 + 32.0
        return t

    def run(self):
        self._temp = self.read_temp()
        self._history.append(self._temp[0])
        while len(self._history) > self.HIST:
            self._history.pop(0)
        self._t = threading.Timer(1, self.run)
        self._t.daemon = True
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
            
            if self.units == 'metric' and self._test: print '%f C' % temp_c
            
            temp_f = temp_c * 9.0 / 5.0 + 32.0
            if self.units == 'imperial' and self._test: print '%f F' % temp_f 
            self.changed.emit(self)
            
            return (temp_c, temp_f)
            
        return self._temp
    
    def onChange(self):
        if self._test: print '%f C' % self._temp[0], self._hilo, self._history
        if all(t < (self._hilo[1] - 0.5) for t in self._history):
            self.heat = True
            self.cool = False
            self.fan = not self._auto
        elif all(t > (self._hilo[0] + 0.5) for t in self._history):
            self.heat = False
            self.cool = True
            self.fan = True
        else:
            self.heat = False
            self.cool = False
            self.fan = not self._auto
        #print self._hilo

    def start(self):
        self.stop()        
        self.run()

    def stop(self):
        if(self._t is not None):
            print 'Stopping thread...'
            self._t.cancel()
            self._t = None
            GPIO.output(self.HEAT, False)
            GPIO.output(self.COOL, False)
            GPIO.output(self.FAN, False)

if __name__ == "__main__":
    from PyQt4.QtCore import QCoreApplication
    import sys, pdb
    
    app = QCoreApplication(sys.argv)
    
    # Testing the thermostat on the console
    t = Thermostat(parent=app, test=True)
    t.start()
    
    def uncaught(type, value, traceback):
        print type, value, traceback
        QCoreApplication.quit()
        
    sys.excepthook = uncaught
    
    app.exec_()
    
    print 'Stopping...'
    t.stop()