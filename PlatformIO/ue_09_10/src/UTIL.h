#ifndef _UTIL_H
#define _UTIL_H
#include <stdint.h>
#include <Arduino.h>

const int segmentPins[] = {62, 63, 64, 65, 66, 67, 68, 69};
const int buttonPins[] = {9, 8, 7, 6, 38, 39, 40, 41};
const int ledPins[] = {49, 48, 47, 46, 45, 44, 43, 42};

const int numbersSeg7[] = {
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
const int numSegments = sizeof(segmentPins) / sizeof(segmentPins[0]);
const int numButtons = sizeof(buttonPins) / sizeof(buttonPins[0]);
const int numLeds = sizeof(ledPins) / sizeof(ledPins[0]);

void initLed(void);
void initSeg7(void);
void initButtons(void);
void initAll(void);
bool kbhit(void);  
uint8_t getch(void);  
void clearLed(void);
void clearSeg7(void);
void setSeg7(uint8_t nr); 
int binaryToBcd(int binaryValue);

#endif