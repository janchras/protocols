#include <Adafruit_NeoPixel.h>
#include <avr/power.h>

#define PIN 2         //Ausgang Arduino UNO zur Ansteuerung der LEDs
#define NUMPIXELS 121 //Anzahl der LEDs
#define NUMLEDSTROM 10

Adafruit_NeoPixel pixels = Adafruit_NeoPixel(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

int i=1;
int a=1;    //Sekunde kommt vom Interrupt
int mm=1;   //Minute
int hh=1;   //Stunde
int b=1;   //Sekundeneinsprung für LED-Daten
char c=1,d; //Variable für Serial Monitor Abfrage Verzögerung eine Sekunde
char e,f=0; //Variable für Wecker, Verzögerung eine Sekunde
int k,l;
unsigned char rot=64;
unsigned char gruen=64;
unsigned char blau=64;
int ldrpin=5;
//unsigned char ldrwert,hellwert=32;
int ldrwert;
unsigned char hellwert1,hellwert;
int mikropin=3;
int ledstrom;
int mittelwert_array[NUMLEDSTROM];
int mittelwert_ledstrom = 0;
int strom;

void setup() 
{
  // put your setup code here, to run once:
  pixels.begin();
  pinMode(4,INPUT_PULLUP); // Taste mit Programm Pull Up 
  pinMode(3,INPUT);
  pinMode(13,OUTPUT);

     
  cli();  //Lösche globales Interrupt-Enable-Bit
  //reset
  TCCR1A = 0; //set TCCR1A register to 0 Löschen des TCCR1A-Registers
  TCCR1B = 0; //set TCCR1B register to 0 Löschen des TCCR1B-Registers
  TCNT1  = 0; //reset counter value

  OCR1A = 15624; //Vergleichsregister, Interrupt wir ausgelöst, wenn Timer den Vergleichswert 
                 //erreicht hat, hat den Wertbereich des Timers, Timer0(2) 8Bit 0-255, Timmer1 16Bit 0-65535 1Sec=15624
  //set prescaler Vorteiler definieren (Vorteiler = 1024)siehe https://arduino-projekte.webnode.at/registerprogrammierung/timer-interrupt/
  TCCR1B |= (1 << CS12) | (1 << CS10); // Setze CS10 und CS12 (Clock Select)
  TCCR1B |= (1 << WGM12);   //turn on CTC mode Setze CTC-Mode (Waveform Generation Mode)
  TIMSK1 |= (1 << OCIE1A);  //enable timer compare interrupt

  sei();  //allow interrupts

  Serial.begin(9600);   //start serial connection
  //mittelwert_array_clear();
}

  ISR(TIMER1_COMPA_vect) //function which will be called when an interrupt occurs at timer 1
  { i++;
   
  }

void loop() 
{ 
  if ((digitalRead(4))==LOW)
    { mm++;
      i=0;    
      delay (400);
      //Serial.print("Taste ein\n");
    }
  
  
  if (i>300) //1Sec x 300 = 5Min deswegen i>300
   {
     i=1;     // Interrupt Sekunde
     mm++;    // Minute Zeit
   }
  if (hh>=12 && mm>12)  //1Std x 12 = 1/2Tag  deswegen hh>=12
  { 
     mm=1;
     hh=1;
  }
  else if (mm>12)       //5Min x 12 = 1Std deswegen mm>12
  {
    mm=1;
    hh++;
  }
  
  ldrwert=(analogRead(ldrpin) >> 1);  // analog Read max. 1023, 2 Nullen links shift = ldrwert max 255
 // ldrwert=(analogRead(ldrpin)); // analog Read max. 1023, 2 Nullen links shift = ldrwert max 255
  if (ldrwert > 255)
  {
    ldrwert = 240;
  }
  hellwert1 = ~ldrwert;                 // ldrwert Bitmuster drehen, z.B. ldrwert 0011 0010 = 50 hellwert 1100 1101 = 205 
  hellwert = hellwert1 >> 1;

  /*  
  if (i!=c)
  {      
    c=i;
    Serial.print("Hellwert ");Serial.print(hellwert);   
    Serial.print("   LDRWert ");Serial.print(ldrwert); 
    Serial.print("\n");
  }
  */
  
  rot=hellwert;
  blau=hellwert;
  gruen=hellwert; 

  ledstrom = analogRead(4);
 // mittelwert_array_aktualisieren();
 // mittelwert_berechnen();
  
  if (i!=c)
  {      
    c=i;
    mittelwert_array_aktualisieren();
    mittelwert_berechnen();
   /* 
    Serial.print("ledstrom ");Serial.print(ledstrom);   
    for (int l = 0; l < NUMLEDSTROM; l++)
      {   Serial.print("  ");Serial.print(mittelwert_array [l]);  
        
      } */
    strom = mittelwert_ledstrom * 22; // 1 Digit = 4,88mV / 0,22 Ohm (Serienwiderstand)   
    Serial.print(" Mittelw ");Serial.print(mittelwert_ledstrom);
    Serial.print(" Strom ");Serial.print(strom);Serial.print(" mA");
    Serial.print("\n");
  } 


  if ((digitalRead(3)) == LOW) //als DI6 falsch in KICad beschriftet
  { htlkaindorf_ein(); 
    esist_aus();
    digitalWrite(13,HIGH);     
  }
  else
  { htlkaindorf_aus();
    esist_ein();
    digitalWrite(13,LOW);       
  }
     
/*      Serial.print("Min ");
      Serial.print(ldrmin);
      Serial.print("   Max ");
      Serial.print(ldrmax);
      Serial.print("   analogred ");
      Serial.print(analogRead(mikropin));
       Serial.print("   Wert ");
      Serial.print(ldrwert);
      Serial.print("\n");
     
 */    
/*  if (i!=c)
    {      
      c=i;
      Serial.print("hh:mm:ss ");
      Serial.print(hh);Serial.print(":");Serial.print(mm);Serial.print(":");Serial.print(i);
      Serial.print("\n");
    }
 */ 
//   esist_ein();
   
   if (mm==1 || mm==5 || mm==7 || mm==11) //FÜNF
   { for(k=7;k<11;k++)
     {pixels.setPixelColor(k, pixels.Color(rot,gruen,blau));
     }
   }
   else
   { for(k=7;k<11;k++)
     {pixels.setPixelColor(k, pixels.Color(0,0,0));
     }
   }
  
   if (mm==2 || mm==8 || mm==10) //ZEHN
   { for(k=29;k<33;k++)
     { pixels.setPixelColor((k), pixels.Color(rot,gruen,blau));
     }
   }  
   else
   { for(k=29;k<33;k++)
     {pixels.setPixelColor(k, pixels.Color(0,0,0));
     }
   }  
      
   if (mm==4) //ZWANZIG
   { for(k=22;k<29;k++)
     { pixels.setPixelColor((k), pixels.Color(rot,gruen,blau));
     }
   }
   else  
   { for(k=22;k<29;k++)
     {  pixels.setPixelColor(k, pixels.Color(0,0,0));
     }       
   }
    
   if (mm==3 || mm==9) //VIERTEL
   { for(k=11;k<18;k++)
     {  pixels.setPixelColor(k, pixels.Color(rot,gruen,blau));
     }
   }
   else
   { for(k=11;k<18;k++)
     {  pixels.setPixelColor(k, pixels.Color(0,0,0));
     } 
   }

   if (mm==9) //DREI vor dem Wort VIERTEL
   { for(k=18;k<22;k++)
     {  pixels.setPixelColor(k, pixels.Color(rot,gruen,blau));
     }
   }
   else
   { for(k=18;k<22;k++)
     {  pixels.setPixelColor(k, pixels.Color(0,0,0));
     } 
   }

   if (mm>=5 && mm<=8) //HALB
   { for(k=33;k<37;k++)
     {  pixels.setPixelColor(k, pixels.Color(rot,gruen,blau));
     }
   }
   else
   { for(k=33;k<37;k++)
     {  pixels.setPixelColor(k, pixels.Color(0,0,0));
     } 
   }

   if (mm==12)    // UHR ein- ausschalten
   { for(k=99;k<=101;k++)
     {  pixels.setPixelColor(k, pixels.Color(rot,gruen,blau));
     }
   } 
   else
   { for(k=99;k<=101;k++)
     {  pixels.setPixelColor(k, pixels.Color(0,0,0));
     }
   }

   if (mm==5 || (mm>=9 && mm<=11))    // VOR ein- ausschalten
   { for(k=37;k<40;k++)
     {  pixels.setPixelColor(k, pixels.Color(rot,gruen,blau));
     }
   } 
   else
   { for(k=37;k<40;k++)
     {  pixels.setPixelColor(k, pixels.Color(0,0,0));
     }
   }
 
   if ((mm>=1 && mm<=4) || (mm>=7 && mm<=8))    // NACH ein- ausschalten
   { for(k=40;k<44;k++)
     {  pixels.setPixelColor(k, pixels.Color(rot,gruen,blau));
     }
   } 
   else
   { for(k=40;k<44;k++)
     {  pixels.setPixelColor(k, pixels.Color(0,0,0));
     } 
   }
 //1.Stunde
   if ((hh==1 && (mm>=5 && mm<=12))||(hh==2 && (mm>=1 && mm<=4)))
   { for(k=45;k<49;k++)
     {  pixels.setPixelColor(k, pixels.Color(rot,gruen,blau));
     }
     if (hh==1 && mm==12)                                     // EIN UHR ohne S bei EINS
     { pixels.setPixelColor(48, pixels.Color(0,0,0));
     } 
   }
   else
   {
     for(k=45;k<49;k++)
     {  pixels.setPixelColor(k, pixels.Color(0,0,0));
     } 
   }
 //2.Stunde
   if ((hh==2 && (mm>=5 && mm<=12))||(hh==3 && (mm>=1 && mm<=4)))
   { for(k=50;k<54;k++)
     {  pixels.setPixelColor(k, pixels.Color(rot,gruen,blau));
     }
   }
   else
   { for(k=50;k<54;k++)
     {  pixels.setPixelColor(k, pixels.Color(0,0,0));
     } 
   } 
 //3.Stunde   
   if ((hh==3 && (mm>=5 && mm<=12))||(hh==4 && (mm>=1 && mm<=4)))
   { for(k=61;k<65;k++)
     {  pixels.setPixelColor(k, pixels.Color(rot,gruen,blau));
     }
   }
   else
   {  for(k=61;k<65;k++)
     {  pixels.setPixelColor(k, pixels.Color(0,0,0));
     } 
   } 
//4.Stunde
   if ((hh==4 && (mm>=5 && mm<=12))||(hh==5 && (mm>=1 && mm<=4)))    
   { for(k=73;k<77;k++)
     {  pixels.setPixelColor(k, pixels.Color(rot,gruen,blau));
     }
   }
   else
   { for(k=73;k<77;k++)
     {  pixels.setPixelColor(k, pixels.Color(0,0,0));
     } 
   } 
//5.Stunde
   if ((hh==5 && (mm>=5 && mm<=12))||(hh==6 && (mm>=1 && mm<=4)))    
   { for(k=83;k<87;k++)
     {  pixels.setPixelColor(k, pixels.Color(rot,gruen,blau));
     }
   }
   else
   { for(k=83;k<87;k++)
     {  pixels.setPixelColor(k, pixels.Color(0,0,0));
     } 
   }
//6.Stunde
   if ((hh==6 && (mm>=5 && mm<=12))||(hh==7 && (mm>=1 && mm<=4)))   
   { for(k=77;k<82;k++)
     {  pixels.setPixelColor(k, pixels.Color(rot,gruen,blau));
     }
   }
   else
   { for(k=77;k<82;k++)
     {  pixels.setPixelColor(k, pixels.Color(0,0,0));
     }
   }
//7.Stunde 
   if ((hh==7 && (mm>=5 && mm<=12))||(hh==8 && (mm>=1 && mm<=4)))    
   { for(k=66;k<72;k++)
     {  pixels.setPixelColor(k, pixels.Color(rot,gruen,blau));
     }
   }
   else
   { for(k=66;k<72;k++)
     {  pixels.setPixelColor(k, pixels.Color(0,0,0));
     } 
   }
//8.Stunde
   if ((hh==8 && (mm>=5 && mm<=12))||(hh==9 && (mm>=1 && mm<=4)))     
   { for(k=89;k<93;k++)
     {  pixels.setPixelColor(k, pixels.Color(rot,gruen,blau));
     }
   }
   else
   { for(k=89;k<93;k++)
     {  pixels.setPixelColor(k, pixels.Color(0,0,0));
     } 
   }
 //9.Stunde
    if ((hh==9 && (mm>=5 && mm<=12))||(hh==10 && (mm>=1 && mm<=4)))
   { for(k=106;k<110;k++)
     {  pixels.setPixelColor(k, pixels.Color(rot,gruen,blau));
     }
   }
   else
   { for(k=106;k<110;k++)
     {  pixels.setPixelColor(k, pixels.Color(0,0,0));
     } 
   }
//10.Stunde
   if ((hh==10 && (mm>=5 && mm<=12))||(hh==11 && (mm>=1 && mm<=4)))
   { for(k=94;k<98;k++)
     {  pixels.setPixelColor(k, pixels.Color(rot,gruen,blau));
     }
   }
   else
   { for(k=94;k<98;k++)
     {  pixels.setPixelColor(k, pixels.Color(0,0,0));
     } 
   }
//11.Stunde
   if ((hh==11 && (mm>=5 && mm<=12))||(hh==12 && (mm>=1 && mm<=4)))
   { for(k=103;k<106;k++)
     {  pixels.setPixelColor(k, pixels.Color(rot,gruen,blau));
     }
   }
   else
   { for(k=103;k<106;k++)
     {  pixels.setPixelColor(k, pixels.Color(0,0,0));
     } 
   }
 //12.Stunde
   if ((hh==12 && (mm>=5 && mm<=12))||(hh==1 && (mm>=1 && mm<=4)))
   { for(k=55;k<60;k++)
     {  pixels.setPixelColor(k, pixels.Color(rot,gruen,blau));
     }
   }
   else
   { for(k=55;k<60;k++)
     {  pixels.setPixelColor(k, pixels.Color(0,0,0));
     }
   }
  if (i!=b)
  { b=i;
    pixels.show();
  }     
}

void htlkaindorf_ein()
{
  for(k=110;k<122;k++)
     {  pixels.setPixelColor(k, pixels.Color(rot,0,0)); //HTL Kaindorf ein
     } 
}

void htlkaindorf_aus()
{
  for(k=110;k<122;k++)
     {  pixels.setPixelColor(k, pixels.Color(0,0,0)); //HTL Kaindorf aus
     } 
} 

void esist_ein()
{ pixels.setPixelColor(0, pixels.Color(0,0,(blau*2)));    //E
  pixels.setPixelColor(1, pixels.Color(0,0,(blau*2)));    //S  
  { for(k=3;k<6;k++)
    {pixels.setPixelColor(k, pixels.Color(0,0,(blau*2))); //IST
    }
  }
}

void esist_aus()
{ pixels.setPixelColor(0, pixels.Color(0,0,0));    //E
  pixels.setPixelColor(1, pixels.Color(0,0,0));    //S  
  { for(k=3;k<6;k++)
    {pixels.setPixelColor(k, pixels.Color(0,0,0)); //IST
    }
  }
}

void mittelwert_array_clear() 
{
  for (int l = 0; i < NUMLEDSTROM; l++) 
  {  mittelwert_array[l] = 0;
  }
}

void mittelwert_array_aktualisieren() 
{
  for (int l = 0; l < (NUMLEDSTROM - 1); l++) 
  {
    mittelwert_array[l] = mittelwert_array[l + 1];
  }
  mittelwert_array[NUMLEDSTROM - 1] = ledstrom;
}

void mittelwert_berechnen() 
{
  int summe = 0;
  for (int l = 0; l < NUMLEDSTROM; l++)
  {
    summe += mittelwert_array[l];
  }

  mittelwert_ledstrom = summe / NUMLEDSTROM;
}