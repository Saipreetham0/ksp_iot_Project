#include <SharpIR.h>
#include <TimeLib.h> // Include Time library
#define IRPin A1
#define IRPin2 A3
#define model 20150
#define model2 20150
#define MIN_THRESHOLD 20
#define MAX_THRESHOLD 150
int distance_cm;
int distance2_cm;
int threshold_sensor1_open; // User-defined threshold value for sensor 1 to open relay 1
int threshold_sensor1_close; // User-defined threshold value for sensor 1 to close relay 1
int threshold_sensor2_open; // User-defined threshold value for sensor 2 to open relay 2
int threshold_sensor2_close; // User-defined threshold value for sensor 2 to close relay 2
bool relay1_state = false; // Variable to store the state of relay 1
bool relay2_state = false; // Variable to store the state of relay 2
SharpIR mySensor = SharpIR(IRPin, model);
SharpIR mySensor2 = SharpIR(IRPin2, model2);
int readThresholdValue();
void waitForEnter();

void setup() {
    // put your setup code here, to run once:
    Serial.begin(9600);
    pinMode(2, OUTPUT);
    pinMode(3, OUTPUT);
    setTime(8, 0, 0, 1, 1, 2024); // Set initial time (8:00 AM)

    // Prompt user to enter threshold values
    Serial.println("Enter threshold value for sensor 1 to open relay 1:");
    while (!Serial.available()) {} // Wait for user input
    threshold_sensor1_open = Serial.parseInt();
    waitForEnter(); // Wait for user to press Enter
    Serial.println("Enter threshold value for sensor 1 to close relay 1:");
    while (!Serial.available()) {} // Wait for user input
    threshold_sensor1_close = Serial.parseInt();
    waitForEnter(); // Wait for user to press Enter
    Serial.println("Enter threshold value for sensor 2 to open relay 2:");
    while (!Serial.available()) {} // Wait for user input
    threshold_sensor2_open = Serial.parseInt();
    waitForEnter(); // Wait for user to press Enter
    Serial.println("Enter threshold value for sensor 2 to close relay 2:");
    while (!Serial.available()) {} // Wait for user input
    threshold_sensor2_close = Serial.parseInt();
    waitForEnter(); // Wait for user to press Enter
}

// Function to wait for user to press Enter
void waitForEnter() {
    while (!Serial.available()) {} // Wait for user input
    while (Serial.available()) { // Clear serial input buffer
        Serial.read();
    }
}

// Function to read threshold value from user input
int readThresholdValue() {
    while (!Serial.available()) {} // Wait for user input
    int value = Serial.parseInt(); // Read integer value from serial input
    return value;
}

// Function to handle re-entering threshold values
void handleThresholdInput(int &threshold) {
    do {
        threshold = readThresholdValue(); // Read threshold value from user
        if (!isThresholdValid(threshold)) {
            Serial.println("Invalid value. Please re-enter (between 20 and 150):");
        }
    } while (!isThresholdValid(threshold)); // Repeat until a valid value is entered
}

// Function to check if a threshold value is within an acceptable range
bool isThresholdValid(int value) {
    return (value >= MIN_THRESHOLD && value <= MAX_THRESHOLD);
}

void loop() {
    // Get current time
    int currentHour = hour();

    // Get a distance measurement and store it as distance_cm:
    distance_cm = mySensor.distance();
    distance2_cm = mySensor2.distance();

    // Check if it's time to open relay 1 and relay 1 is currently off
    if (currentHour == 8 && !relay1_state && distance_cm >= threshold_sensor1_open) {
        digitalWrite(2, HIGH); // Open relay 1
        relay1_state = true; // Update relay 1 state
        Serial.println("Relay 1 is ON");
    }

    // Check if it's time to close relay 1 and relay 1 is currently on
    if ((currentHour >= 8 && currentHour < 20) && relay1_state && distance_cm <= threshold_sensor1_close) {
        digitalWrite(2, LOW); // Close relay 1
        relay1_state = false; // Update relay 1 state
        Serial.println("Relay 1 is OFF");
    }

    // Check if it's time to open relay 2 and relay 2 is currently off
    if (currentHour == 10 && !relay2_state && distance2_cm >= threshold_sensor2_open) {
        digitalWrite(3, HIGH); // Open relay 2
        relay2_state = true; // Update relay 2 state
        Serial.println("Relay 2 is ON");
    }

    // Check if it's time to close relay 2 and relay 2 is currently on
    if ((currentHour >= 10 && currentHour < 22) && relay2_state && distance2_cm <= threshold_sensor2_close) {
        digitalWrite(3, LOW); // Close relay 2
        relay2_state = false; // Update relay 2 state
        Serial.println("Relay 2 is OFF");
    }

    // Print the measured distance to the serial monitor:
    Serial.print("Sensor 1: ");
    Serial.print(distance_cm);
    Serial.println(" cm");

    Serial.print("Sensor 2: ");
    Serial.print(distance2_cm);
    Serial.println(" cm");

    delay(1000);
}
