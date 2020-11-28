import RPi.GPIO as GPIO
from time import sleep

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)

button = 16
led = 18

GPIO.setup(button, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(led, GPIO.OUT)

GPIO.output(led, GPIO.HIGH)
sleep(3)
GPIO.output(led, GPIO.LOW)

while True:
    if GPIO.input(button) == GPIO.HIGH:
        print("BUTTON PRESS")
