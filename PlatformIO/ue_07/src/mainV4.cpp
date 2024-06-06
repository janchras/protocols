#include <Arduino.h>
const int segmentPins[] = {62, 63, 64, 65, 66, 67, 68, 69};  // Die Pins, die die Segmente des Displays steuern
const int buttonPins[] = {9, 8, 7, 6, 38, 39, 40, 41}; // Die Pins, die die Tasten steuern
const int ledPins[] = {49, 48, 47, 46, 45, 44, 43, 42}; // Die Pins, die die LEDs steuern

const int numbers[] = {
  B11000000,  // 0
  B11111001,  // 1
  B10100100,  // 2
  B10110000,  // 3
  B10011001,  // 4
  B10010010,  // 5
  B10000010,  // 6
  B11111000,  // 7
  B10000000,  // 8
  B10010000   // 9
};

void setSeg7(uint8_t nr);

void setup() {
  for (int i = 0; i < 8; i++) {
    pinMode(segmentPins[i], OUTPUT);
    pinMode(ledPins[i], OUTPUT);
  }
  for (int i = 0; i < 8; i++) {
    pinMode(buttonPins[i], INPUT_PULLUP);
  }
}

int buttonPressed;
int Interval = 1000;
int currentTime = Interval;
int currentNumber = 0;

void loop() {
  if(millis() >= currentTime) {
    currentTime += Interval;
    setSeg7(currentNumber++);
    if (currentNumber > 9) {
      currentNumber = 0;
    }
  }
  buttonPressed = -1;
  for (int i = 0; i < 8; i++) {
    if (digitalRead(buttonPins[i]) == LOW) {
      buttonPressed = i;
      break;
    }
  }
  if (buttonPressed != -1) {
    for (int i = 0; i < 8; i++) {
      digitalWrite(ledPins[i], LOW); 
    }
    digitalWrite(ledPins[buttonPressed], HIGH);
  }
}

void setSeg7(uint8_t nr)
{
  for (int j = 0; j < 8; j++) {
    digitalWrite(segmentPins[j], bitRead(numbers[nr], j));
  }
}