# External module imports
import RPi.GPIO as GPIO
import time
import requests
import json

#no;led;button
#1;17;4
#2;18;5
#3;19;6
#4;20;24
led = {}
button = {}

led[1] = 17
led[2] = 18
led[3] = 19
led[4] = 20

button[1] = 4
button[2] = 5
button[3] = 6
button[4] = 24

def dispatchevent(msg):
   url = 'http://127.0.0.1:8080/api/event/'
   url+=msg
   payload = {'some': 'data'}
   # Create your header as required
   headers = {"content-type": "application/json"}
   try:
      r = requests.put(url, data=json.dumps(payload), headers=headers, timeout=2)
   except:
      print("no http connection")

# Pin Definitons:
#ledPin = led[but]
#buttonPin = button[but]

# Pin Setup:
for but in button:
	GPIO.setmode(GPIO.BCM) # Broadcom pin-numbering scheme
	GPIO.setup(led[but], GPIO.OUT) # LED pin set as output
	GPIO.setup(button[but], GPIO.IN) # button pin set as input

print("Here we go! Press CTRL+C to exit")
try:
    tcmd=0
    while 1:
	for but in button:
		if GPIO.input(button[but]): # button is released
		    GPIO.output(led[but], GPIO.HIGH)
                    if but==1 and (time.time() - tcmd) >= 1:
		       print but
                       dispatchevent("cis1/dh1/airb1/a123/H/P1/progress/12000")
                    if but==2  and (time.time() - tcmd) >= 1:
		       print but
                       dispatchevent("cis1/dh1/airb1/a123/H/P2/progress/6000")
                    if but==3  and (time.time() - tcmd) >= 1:
		       print but
                       dispatchevent("cis1/dh2/airb1/a123/H/P3/progress/6000")
                    if but==4  and (time.time() - tcmd) >= 1:
		       print but
                       dispatchevent("cis1/dh2/airb1/a123/H/P4/done/0")
                    tcmd=time.time()
		else: # button is pressed:
		    GPIO.output(led[but], GPIO.LOW)
	time.sleep(0.075)
except KeyboardInterrupt: # If CTRL+C is pressed, exit cleanly:
    pwm.stop() # stop PWM
    GPIO.cleanup() # cleanup all GPIO


