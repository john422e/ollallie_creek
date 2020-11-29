import subprocess
import RPi.GPIO as GPIO
from time import sleep

# Hifiberry Miniamp uses GPIO pins 16, 18, 19, 20, 21, 26

button_state = "OFF"
button_pin = 12
led_pin = 17

def button_callback(channel):
    print("BUTTON PRESS")
    global button_state
    global led_pin

    if button_state == "OFF":
        print("LIGHT ON")
        GPIO.output(led_pin, GPIO.HIGH)
        button_state = "ON"
        result = subprocess.run( ["python3", "ultrasonic_test.py"], check=True)
        sleep(1)
        print(result)
        #subprocess.run("chuck --srate:22050 --adaptive:256 /home/pi/git/still_life/ollallie_creek/test.ck &")
        #os.system("python3 /home/pi/git/still_life/ollallie_creek/oscDistance_still_life.py &")
        #os.system("chuck --srate:22050 --adaptive:256 /home/pi/git/still_life/ollallie_creek/test.ck &")
    else:
        print("LIGHT OFF")
        GPIO.output(led_pin, GPIO.LOW)
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
