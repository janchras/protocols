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
  Serial.begin(115200);
  // Set the LED pins as output
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
}

void loop() {
  // Iterate through the colors and light up the LED for one second for each color
  analogWrite(redPin, 0);
  analogWrite(greenPin, 255);
  analogWrite(bluePin, 255);
  delay(10300);
  for (int i = 0; i < 7; i++) {
    analogWrite(redPin, colors[i][0]);
    Serial.print(colors[i][0]);
    Serial.print(" ");
    Serial.print(colors[i][1]);
    Serial.print(" ");
    Serial.println(colors[i][2]);
    analogWrite(greenPin, colors[i][1]);
    analogWrite(bluePin, colors[i][2]);
    delay(1000);
  }
}


//https://wokwi.com/projects/306455554559050306