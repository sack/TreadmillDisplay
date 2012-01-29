#!/usr/bin/python2.6
# -*- coding: iso-8859-1 -*-
import twitter
import serial
import time
import TwSearch

ser = serial.Serial('/dev/tty.usbmodemfd121', 115200)



def checkokay():
    print 'recup mesg'
    ser.flushInput()
    time.sleep(3)
    print 'affichage'
    info = TwSearch.search('tetalab')

    for tweet in info["results"]:
        print tweet["from_user"] + '\n' + tweet['text'].upper().encode(
                "ascii",'replace')
        ser.write(tweet['text'].upper().encode( "ascii",'replace'))
        ser.flushInput()
        #a modifier pour laisser le tps a l'affichage
        time.sleep(10)

print 'Twitter to Tetatapis !'
while 1:
    checkokay()
time.sleep(5)




