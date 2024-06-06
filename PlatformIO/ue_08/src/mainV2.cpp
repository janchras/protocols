#include <Arduino.h>

int redPin = 5;
int greenPin = 3;
int bluePin = 2;

int colors[7][3] = {
    {255, 0, 0}, // Rot
    {255, 255, 0}, // Gelb
    {255, 255, 255}, // Weiß
    {0, 255, 0}, // Grün
    {0, 255, 255}, // Cyan
    {255, 0, 255}, // Magenta
    {0, 0, 255} // Blau
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