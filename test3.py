import RPi.GPIO as GPIO
from time import sleep

def button_callback(channel):
    print("BUTTON PRESS")

button = 16
led = 18

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)

GPIO.setup(button, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(led, GPIO.OUT)
GPIO.add_event_detect(button, GPIO.RISING, callback=button_callback)

message = input("Press enter to quit \n")
GPIO.cleanup()


GPIO.output(led, GPIO.HIGH)
sleep(3)
GPIO.output(led, GPIO.LOW)
