import RPi.GPIO as GPIO
import time

ledPin = 18
butPin = 16

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)
GPIO.setup(button_pin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

while(true):
    if GPIO.input(butPin):
        print("BUTTON PRESS")
    time.sleep(0.25)
