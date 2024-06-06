#include <Arduino.h>
#define MAXSTR 80
int ledPin[] = {49, 48, 47, 46, 45, 44, 43, 42};

char rx0Str[MAXSTR] = "";
char *token = NULL;
bool rx0Flag = false;

void setup()
{
  Serial.begin(9600);
  for(int j = 0; j <= 7; j++)
  {
    pinMode(ledPin[j], OUTPUT);
  }
}

void loop()
{
  if (rx0Flag)
  {
    rx0Flag = false;
    Serial.println(rx0Str);       // Ausgabe zu Debugging-Zwecken
    token = strtok(rx0Str, " ");  // 1. Token
    if (token != NULL)
    {
      if(!strcmp(token, "SET"))
      {
        if((token = strtok(NULL, " ")) != NULL)
        {
          if(!strcmp(token, "LED"))
          {
            if((token = strtok(NULL, " ")) != NULL)
            {
              int i = atoi(token);
              Serial.println("TEST i");
              Serial.println("i");
              if((token = strtok(NULL, " ")) != NULL)
              {
                if(!strcmp(token, "1"))
                {
                  digitalWrite(ledPin[i], HIGH);
                  char buffer[50];
                  sprintf(buffer, "LED %d wird angesteuert, Pin %d", i, ledPin[i]);
                  Serial.println(buffer);
                }
                else if(!strcmp(token, "0"))
                {
                  digitalWrite(ledPin[i], LOW);
                }
              }
              if(!strcmp(token, ""))
              {
                // ToDo
              }
              else if(!strcmp(token, "OFF"))
              {
                // ToDo
              }
            }
          }
        }
      }
    }
  }
}

void serialEvent()
{
  static char tempStr[MAXSTR] = "";
  static uint8_t cnt = 0;
  while (Serial.available()) // solange Zeichen vorhanden sind
  {
    char ch = Serial.read();      // Zeichen einlesen
    if (ch == '\n' || ch == '\r') // wenn String beendet
    {                             // fertig
      tempStr[cnt] = 0;           // Stringabschluss
      cnt = 0;                    // vorbereiten fuer naechsten String
      strcpy(rx0Str, tempStr);    // kopieren
      rx0Flag = true;             // Flag setzen
    }
    else
    {
      tempStr[cnt++] = ch; // Zeichen speichern
      if (cnt >= MAXSTR)   // Sicherheitsprogrammierung
      {
        cnt = 0;
      }
    }
  }
}