
import win32api, win32con
import numpy as np
import cv2
import random
import time
import os
import keyboard


def leftClick(x,y):
    win32api.SetCursorPos((x,y))
    win32api.mouse_event(win32con.MOUSEEVENTF_LEFTDOWN,x,y,0,0)
    time.sleep(.1)
    win32api.mouse_event(win32con.MOUSEEVENTF_LEFTUP,x,y,0,0)

def rightClick(x,y):
    win32api.SetCursorPos((x,y))
    win32api.mouse_event(win32con.MOUSEEVENTF_RIGHTDOWN,x,y,0,0)
    time.sleep(.1)
    win32api.mouse_event(win32con.MOUSEEVENTF_RIGHTUP,x,y,0,0)



#match_found = cv2.imread('Match_Found_pic.png')
#warning = cv2.imread('warning.png')

#test = cv2.matchTemplate(??,match_found,cv2.TM_CCOEFF_NORMED)


#def beginGame():
#    mousePos((855,850))                 #FIND MATCH button
#    leftClick()
#    time.sleep(12)                      #Need to figure out how to get screen to see when que pops
#    mousePos((960,717))
#
#    mousePos((1106,265))                #Search bar for champion select
#    leftClick()
#    time.sleep(.1)
#    press('m','i','s','s')
#    time.sleep(.1)
#    mousePos((703,323))                 #Click on champion
#    leftClick()


def startOfGame():
    time.sleep(3)
    leftClick(100,600)
    time.sleep(1)
    keyboard.send('p')
    time.sleep(1)
    leftClick(373,250)
    time.sleep(.05)
    leftClick(373,250)
    time.sleep(14)
    leftClick(1582,86)
    time.sleep(1)
    keyboard.send('ctrl+w')
    time.sleep(.2)
    leftClick(1780,941)
    time.sleep(70)

def attack():
    leftClick(random.randint(1534,1634),random.randint(128,228))
    keyboard.send('w')
    time.sleep(random.randint(5,18)*.3)

def retreat():
    rightClick(random.randint(405,505),random.randint(701,801))
    time.sleep(random.randint(10,20)*.1)

startOfGame()
for i in range(121):
    print(i)
    keyboard.send('ctrl+r')
    time.sleep(.1)
    keyboard.send('ctrl+w')
    time.sleep(.1)
    keyboard.send('ctrl+q')
    time.sleep(.1)
    keyboard.send('ctrl+e')
    attack()
    if i == 1000:
        press('p')
        time.sleep(1)
        leftClick(640,618)
        leftClick(640,618)
        time.sleep(.5)
        leftClick(461,634)
        leftClick(461,634)
        time.sleep(.5)
        leftClick(373,619)
        time.sleep(.4)
    if i % 5 == 0 and i < 30 and i > 19:
        retreat()
        time.sleep(2)
        leftClick(1884,837)
        time.sleep(random.randint(12,15))
        keyboard.send('w')
        time.sleep(random.randint(12,15))
    if i % 5 == 0 and i >30:
        retreat()
        time.sleep(2)
        leftClick(1884,837)
        time.sleep(random.randint(22,25))
        keyboard.send('w')
        time.sleep(random.randint(20,24))
    if i % 2 == 0:
        retreat()
