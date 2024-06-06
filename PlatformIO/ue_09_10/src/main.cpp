#include "UTIL.h"
#include <stdint.h>
#include "lcd12864.h"

const unsigned long TIMER_HIDE_INTERVAL = 2000;
const unsigned long SEC_INTERVAL = 1000;

unsigned long timerStart;
unsigned long timerHideStart;

unsigned long secCounter;
unsigned long milCounter;

int returnValue;
int lineCount;

char* timeStringLCD;

bool secCounterFlag;
bool showCounterFlag;
bool timerHideFlag;
bool firstHit = true;

  void stopCounting();
  void updateDisplay();
  void handleInput();
  void handleCounter();
  void resetTimer();
  char* formatTime(unsigned long secCounter, unsigned long milCounter);

void setup() 
{
  initAll();
  resetTimer();
  //Serial.begin(9600);
  initLcd12864();
}

void loop() 
{
  handleInput();
  if (secCounterFlag && (secCounter < 256)) 
  {
    handleCounter();
  }
}

void handleInput()
{
  if(kbhit())
  {
    if(firstHit)
    {
      firstHit=false;
      switch(getch())
      {
        case 0:
          resetTimer();
          secCounterFlag = true;
          showCounterFlag = true;
          break;
        case 1:
          showCounterFlag = true;
          stopCounting();
          break;
        case 2:
          showCounterFlag = false;
          stopCounting();
          resetTimer();
          break;
        case 3:
          if(secCounterFlag)
          {
            showCounterFlag = false;
            timerHideStart = millis();
            timerHideFlag = true;
          }
          break;
        case 4:
          showCounterFlag = !showCounterFlag;
          break;
        default:
          stopCounting();
          break;
      }
    }
  	// Serial Monitor input	
    /*
    Serial.print(returnValue);
    Serial.print(" ");
    lineCount++;
    if(lineCount>20)
    {
      lineCount = 0;
      Serial.println();
    }
  */
  }
  else
  {
    firstHit=true;
  }
}

void stopCounting(void)
{
  secCounterFlag = false;
  timerHideFlag = false;
  updateDisplay();
}

void updateDisplay() 
{
  timeStringLCD = formatTime(secCounter, milCounter);
  //Serial.println(timeStringLCD);
  blankLcd12864();
  printLcd12864(0, 0, timeStringLCD);
  if (showCounterFlag) 
  {
    for (int i = 0; i < numLeds; i++) 
    {
      digitalWrite(ledPins[i], bitRead(secCounter, i));
    }
    setSeg7((milCounter / 100)%10);
  }
}

void handleCounter() 
{
  milCounter = millis() - timerStart;
  updateDisplay();
  if (timerHideFlag && (millis() >= (timerHideStart + TIMER_HIDE_INTERVAL))) 
  {
    timerHideFlag = false;
    showCounterFlag = true;
  }
  secCounter = milCounter/SEC_INTERVAL;
}

void resetTimer() 
{
  timerStart = millis();
  timerHideStart = 0;

  secCounter = 0;
  milCounter = 0;

  secCounterFlag = false;
  showCounterFlag = false;
  timerHideFlag = false;

  clearLed();
  clearSeg7();
  blankLcd12864();
}

char* formatTime(unsigned long secCounter, unsigned long milCounter) 
{
  unsigned long totalSeconds = secCounter;
  unsigned long minutes = totalSeconds / 60;
  unsigned long seconds = totalSeconds % 60;
  unsigned long hundredths = milCounter%100;

  static char returnString[9]; // Format: "mm:ss.hh\0"
  sprintf(returnString, "%02lu:%02lu.%02lu", minutes, seconds, hundredths);

  return returnString;
}

/*
//updateDisplay() mit BCD counter
void updateDisplay() 
{
  if (showCounterFlag) 
  {
    int bcdValue = binaryToBcd(secCounter);
    int reversedBcdValue = 0;
    for (int i = 0; i < numLeds; i++) 
    {
      bitWrite(reversedBcdValue, i, bitRead(bcdValue, numLeds - 1 - i));
    }
    for (int i = 0; i < numLeds; i++) 
    {
      digitalWrite(ledPins[i], bitRead(reversedBcdValue, i));
    }
    setSeg7(milCounter % 10);
  }
} */