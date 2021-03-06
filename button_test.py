import subprocess, os
from threading import Thread
import RPi.GPIO as GPIO
from time import sleep

from random import randint

# Hifiberry Miniamp uses GPIO pins 16, 18, 19, 20, 21, 26

button_state = "OFF"
button_pin = 12
led_pin = 17

test_var = 0

def button_callback(channel):
    print("BUTTON PRESS")
    global button_state
    global led_pin
    global ultrasonic
    global chuck
    global noise

    if button_state == "OFF":
        print("LIGHT ON")
        GPIO.output(led_pin, GPIO.HIGH)
        button_state = "ON"
        #ultrasonic = subprocess.Popen( ["python3", "ultrasonic_test.py"], preexec_fn=os.setsid)#, check=True)
        ultrasonic = subprocess.Popen( ["python3", "oscDistance_still_life.py"], preexec_fn=os.setsid)#, check=True)
        #noise = subprocess.Popen( ["chuck", "long_test.ck"], preexec_fn=os.setsid)
        chuck = subprocess.Popen( ["chuck", "sensor_test.ck"], preexec_fn=os.setsid)
        #test_var = randint(10, 20)
        #print(test_var)
        #chuck = subprocess.Popen( ["chuck", "pi_one_player.ck:1"], preexec_fn=os.setsid)

    else:
        print("LIGHT OFF")
        #print(test_var)
        ultrasonic.kill()
        chuck.kill()
        #noise.kill()
        #kill_python = subprocess.Popen( ["pkill", "python3"])
        #kill_chuck = subprocess.Popen( ["pkill", "chuck"])
        GPIO.output(led_pin, GPIO.LOW)
        try:
            print(result, result2)
        except:
            pass
        button_state = "OFF"

#callback_lambda = lambda x: button_callback(x, button_state)


# initialize min
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM) # use physical pin numbers
# set button_pin to be input and set inital value to be pulled low
GPIO.setup(button_pin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
# set LED output
GPIO.setup(led_pin, GPIO.OUT)

# start up sequence
GPIO.output(led_pin, GPIO.HIGH)
sleep(1)
GPIO.output(led_pin, GPIO.LOW)
sleep(1)

# setup event on pin 10 rising edge
GPIO.add_event_detect(button_pin, GPIO.RISING, callback=button_callback, bouncetime=200)

time = 1
while time < 600:
	sleep(1)
	time += 1
#message = input("Press enter to quit \n\n") # run until someone presses enter
GPIO.cleanup() # cleanup
