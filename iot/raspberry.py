pip3 install RPi.GPIO

import RPi.GPIO as GPIO
import time

PIR = 17
LED = 18

GPIO.setmode(GPIO.BCM)
GPIO.setup(PIR, GPIO.IN)
GPIO.setup(LED, GPIO.OUT)

print("PIR Sensor Initializing...")
time.sleep(2)   # Sensor warm-up time
print("Ready")

try:
    while True:
        if GPIO.input(PIR):
            print("Motion Detected!")
            GPIO.output(LED, GPIO.HIGH)
        else:
            print("No Motion")
            GPIO.output(LED, GPIO.LOW)

        time.sleep(1)

except KeyboardInterrupt:
    GPIO.cleanup()




import RPi.GPIO as GPIO
import time

TRIG = 23
ECHO = 24
BUZZER = 18

GPIO.setmode(GPIO.BCM)

GPIO.setup(TRIG, GPIO.OUT)
GPIO.setup(ECHO, GPIO.IN)
GPIO.setup(BUZZER, GPIO.OUT)

GPIO.output(TRIG, False)

try:
    while True:
        # Send trigger pulse
        GPIO.output(TRIG, True)
        time.sleep(0.00001)
        GPIO.output(TRIG, False)

        # Wait for echo start
        while GPIO.input(ECHO) == 0:
            pulse_start = time.time()

        # Wait for echo end
        while GPIO.input(ECHO) == 1:
            pulse_end = time.time()

        # Calculate distance
        pulse_duration = pulse_end - pulse_start
        distance = pulse_duration * 17150
        distance = round(distance, 2)

        print("Distance:", distance, "cm")

        # Buzzer condition
        if distance < 20:
            GPIO.output(BUZZER, True)
            print("Object Detected - Buzzer ON")
        else:
            GPIO.output(BUZZER, False)

        time.sleep(1)

except KeyboardInterrupt:
    GPIO.cleanup()


import RPi.GPIO as GPIO
import time

SOIL_SENSOR = 17
LED = 18

GPIO.setmode(GPIO.BCM)
GPIO.setup(SOIL_SENSOR, GPIO.IN)
GPIO.setup(LED, GPIO.OUT)

try:
    while True:
        if GPIO.input(SOIL_SENSOR) == 1:
            print("Soil is Dry - Water Needed")
            GPIO.output(LED, GPIO.HIGH)
        else:
            print("Soil is Wet")
            GPIO.output(LED, GPIO.LOW)

        time.sleep(1)

except KeyboardInterrupt:
    GPIO.cleanup()



import RPi.GPIO as GPIO
import time

# GPIO pin setup
RAIN_SENSOR = 17   # Rain sensor digital output
LED = 18           # Optional LED

GPIO.setmode(GPIO.BCM)
GPIO.setup(RAIN_SENSOR, GPIO.IN)
GPIO.setup(LED, GPIO.OUT)

try:
    while True:
        if GPIO.input(RAIN_SENSOR) == 0:
            print("Rain Detected!")
            GPIO.output(LED, GPIO.HIGH)
        else:
            print("No Rain")
            GPIO.output(LED, GPIO.LOW)

        time.sleep(1)

except KeyboardInterrupt:
    GPIO.cleanup()


import RPi.GPIO as GPIO
import time

LED_PIN = 17  # GPIO pin (change if needed)

GPIO.setmode(GPIO.BCM)
GPIO.setup(LED_PIN, GPIO.OUT)

try:
    while True:
        GPIO.output(LED_PIN, GPIO.HIGH)  # LED ON
        time.sleep(1)                    # 1 second

        GPIO.output(LED_PIN, GPIO.LOW)   # LED OFF
        time.sleep(2)                    # 2 seconds

except KeyboardInterrupt:
    print("Program stopped")

finally:
    GPIO.cleanup()


import RPi.GPIO as GPIO
import time

BUZZER_PIN = 18  # GPIO pin (change if needed)

GPIO.setmode(GPIO.BCM)
GPIO.setup(BUZZER_PIN, GPIO.OUT)

try:
    while True:
        GPIO.output(BUZZER_PIN, GPIO.HIGH)  # Buzzer ON
        time.sleep(1)                       # 1 second

        GPIO.output(BUZZER_PIN, GPIO.LOW)   # Buzzer OFF
        time.sleep(2)                       # 2 seconds

except KeyboardInterrupt:
    print("Program stopped")

finally:
    GPIO.cleanup()
