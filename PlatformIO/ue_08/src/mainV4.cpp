#include <Arduino.h>

int redPin = 5;
int greenPin = 3;
int bluePin = 2;

int colors[7][3] = {
    {0, 255, 255}, // Rot
    {0, 0, 255}, // Gelb
    {0, 0, 0}, // Weiß
    {255, 0, 255}, // Grün
    {255, 0, 0}, // Cyan
    {0, 255, 0}, // Magenta
    {255, 255, 0} // Blau
  };

void setup() {
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
}

void loop() {
  for (int i = 0; i < 7; i++) {
    analogWrite(redPin, colors[i][0]);
    analogWrite(greenPin, colors[i][1]);
    analogWrite(bluePin, colors[i][2]);
    delay(1000);
  }
}