import RPi.GPIO as GPIO
from time import sleep

GPIO.setwarnings(False)
GPIO.setmode(BCM)

button = 16
led = 18

GPIO.setup(button, GPIO.IN, pull_updown=GPIO.PUD_UP)
GPIO.setup(led, GPIO.OUT)

GPIO.output(led, GPIO.HIGH)
sleep(3)
GPIO.output(led, GPIO.LOW)
