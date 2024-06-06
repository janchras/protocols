#include <Arduino.h>

// Define the pins for the LEDs
const int ledPins[] = {5, 3, 2};

// Define the binary values for each LED color
const int colors[] = {
  B000, // White
  B001, // Blue
  B010, // Green
  B011, // Cyan
  B100, // Red
  B101, // Magenta
  B110, // Yellow
  B111  // White
};

void setup() {
  // Set the LED pins as outputs
  for(int i = 0; i<3; i++){
    pinMode(ledPins[i], OUTPUT);
  }
}
  
void loop() {
  // Loop through each LED
  for(int i = 0; i<3; i++) {
    // Loop through each color
    for(int j = 0; j<3; j++) {
      // Set the LED to the corresponding color
      digitalWrite(ledPins[i], bitRead(colors[i], j));
    }
    // Delay for one second before changing the LED color
    delay(1000);
  }
}