#include "UTIL.h" //Path: src/UTIL.h

void initSeg7(void)
{
  for (int i = 0; i < numSegments; i++)
  {
    pinMode(segmentPins[i], OUTPUT);
  }
}

void initLed(void)
{
  for (int i = 0; i < numLeds; i++)
  {
    pinMode(ledPins[i], OUTPUT);
  }
}

void initButtons(void)
{
  for (int i = 0; i < numButtons; i++)
  {
    pinMode(buttonPins[i], INPUT_PULLUP);
  }
}

void initAll(void)
{
  initLed();
  initSeg7();
  initButtons();
}

bool kbhit(void)
{
  for (int i = 0; i < 8; i++)
  {
    if (digitalRead(buttonPins[i]) == LOW)
    return true;
  }
  return false;
}

uint8_t getch(void)
{
  while (!kbhit())
    ;

  for (int i = 0; i < 8; i++)
  {
    if (!digitalRead(buttonPins[i])) 
    {
      return i;
    }
  }
  return 0;
}

void clearLed(void)
{
  for (int i = 0; i < numLeds; i++)
  {
    digitalWrite(ledPins[i], LOW);
  }
}

void clearSeg7(void)
{
  for (int i = 0; i < numSegments; i++)
  {
    digitalWrite(segmentPins[i], LOW);
  }
}

void setSeg7(uint8_t nr)
{
  for (int j = 0; j < 8; j++) 
  {
    digitalWrite(segmentPins[j], bitRead(numbersSeg7[nr], j));
  }
}

int binaryToBcd(int binaryValue)
{
  if(binaryValue < 0 || binaryValue > 9999) {
    return -1;
  }

  int bcdValue = 0;
  int multiplier = 1;

  while(binaryValue > 0)
  {
    bcdValue += (binaryValue % 10) * multiplier;
    binaryValue /= 10;
    multiplier *= 16;
  }

  return bcdValue;
}