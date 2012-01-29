#include <Wire.h>
/* 
 Treadmill display
 Fabrice Fourc | powered by the tetalab crew 2011
 in bricole we trust
*/

#include "font.h"

char _[] = {'0','0','0','0','0','0','0','0',
               '0','0','0','0','0','0','0','0',
               '0','0','0','0','0','0','0','0',
               '0','0','0','0','0','0','0','0',
               '0','0','0','0','0','0','0','0',
               '0','0','0','0','0','0','0','0'};

int letterSpace;
int dotTime;
byte maxAddress=0x11;


int letterSize = 6;
byte Pos1L1;
byte Pos2L1;
byte Pos1L2;
byte Pos2L2;
int maxRow = 16;

void setup()
{
  Wire.begin();

  //init du max
  Send(maxAddress, 0xf, 0x10);  
  Send(maxAddress, 0x6, 0x00);  
  Send(maxAddress, 0x7, 0x00);  
  Send(maxAddress, 0x2, 0xff);  
  Send(maxAddress, 0x3, 0xff);
  Send(maxAddress, 0xe, 0xff); 


  // espace entre les lettres
  letterSpace = 300 ;
  // espace entre les pixels
  dotTime = 100;

  Serial.begin(115200); 

}


void loop()
{
  char ch;
  if (Serial.available()){
      ch=Serial.read();
      if (ch >='a' && ch <= 'z'){
          printLetter(letter[ch -'a'],letter[ch -'a']);
      }
      if (ch >='A' && ch <= 'Z'){
          printLetter(letter[ch -'A'],letter[ch -'A']);
      }
     if (ch ==' '){
          delay(letterSpace);
      }
      delay(letterSpace);
    
   }


}


void printLetter(char letter1[],char letter2[])
{



  //for each row
  int row=0;
  int col=0;
  for (int i=0; i<letterSize;i++)
  {
    byte colData[16];
    int t=0; //index des paire de valeur pour le max 
    boolean fort=true;
    for (int row=0; row < 8; row++){
     Serial.println(row+col);
      if (fort){
        Pos1L1=letter1[row+col];
        Pos1L2=letter2[row+col];
        fort=false;

      }
      else{

        Pos2L1=letter1[row+col];
        Pos2L2=letter2[row+col];
        //char foo[10]; 
        //sprintf(foo,"Pos1: %i Pos2: %x",Pos1,Pos2);
        //Serial.println(foo);
        colData[t]=Read2HEXtoDEC(Pos1L1,Pos2L1);
        colData[t+4]=Read2HEXtoDEC(Pos1L2,Pos2L2);
        fort=true;
        t++;
        
      }
     
    }
    //Serial.println("send -> position : ");
    //Serial.print(col);
    col+=8;
    SendCol(maxAddress, 0x10, colData);
/*for (int i = 0; i < 8; i++){
        Serial.println(colData[i]);
      }*/
      t=0;
     delay(dotTime);
     erase(_,_);
  } 

}


void erase(char letter1[],char letter2[])
{



  //for each row
  int row=0;
  int col=0;
  for (int i=0; i<letterSize;i++)
  {
    byte colData[16];
    int t=0; //index des paire de valeur pour le max 
    boolean fort=true;
    for (int row=0; row < 8; row++){
     Serial.println(row+col);
      if (fort){
        Pos1L1=letter1[row+col];
        Pos1L2=letter2[row+col];
        fort=false;

      }
      else{

        Pos2L1=letter1[row+col];
        Pos2L2=letter2[row+col];
        //char foo[10]; 
        //sprintf(foo,"Pos1: %i Pos2: %x",Pos1,Pos2);
        //Serial.println(foo);
        colData[t]=Read2HEXtoDEC(Pos1L1,Pos2L1);
        colData[t+4]=Read2HEXtoDEC(Pos1L2,Pos2L2);
        fort=true;
        t++;
        
      }
     
    }
    //Serial.println("send -> position : ");
    //Serial.print(col);
    col+=8;
    SendCol(maxAddress, 0x10, colData);
/*for (int i = 0; i < 8; i++){
        Serial.println(colData[i]);
      }*/
      t=0;
     // delay(dotTime);
  } 

}

void SendCol(byte addr, byte reg, byte colData[])
{

  Wire.beginTransmission(addr);
  Wire.send( reg);

  for (int i=0;i<8;i++){
    Wire.send( colData[i]);
  }
  Wire.endTransmission();
}

int Read2HEXtoDEC(byte Pos2,byte Pos1)
{

  // Now convert the HEX to DEC

  int DECval = 0;

  if(Pos2 <= 57) // Convert Pos2 from 16 base to 10 base
  {
    DECval = DECval + Pos2-48;
  }
  else
  {
    DECval = DECval + Pos2-55;
  }

  if(Pos1 <= 57) // Convert Pos1 from 16 base to 10 base
  {
    DECval = DECval + 16*(Pos1-48);
  }
  else
  {
    DECval = DECval + 16*(Pos1-55);
  }

  return ~DECval;
}

// Send I2C data
void Send(byte addr, byte reg, byte data)
{

  Wire.beginTransmission(addr);
  Wire.send( reg);
  Wire.send( data);
  Wire.endTransmission();
}


