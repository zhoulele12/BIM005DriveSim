#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>

const uint64_t pipeOut = 0xE9E8F0F0E1LL;

RF24 radio(9,10);

struct Signal{
  byte throttle;
  byte turn;
  byte dir;
};

Signal data;
#define BRAKE_PEDAL A1 // the FSR and 10K pulldown are connected to A0
#define GAS_PEDAL A0
#define first A2
#define second A3
#define third A4
#define fourth A5

void ResetData() 
{
  data.throttle = 0;

}
void setup() {
  Serial.begin(9600);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(2, INPUT);
  pinMode(6, INPUT);
  pinMode(7, INPUT);
  pinMode(8, INPUT);
  radio.begin();
  radio.openWritingPipe(pipeOut);
  radio.stopListening();
//  ResetData();
}
 
void loop() {
  // put your main code here, to run repeatedly:
  int brakeReading = analogRead(BRAKE_PEDAL);
  int gasReading = analogRead(GAS_PEDAL);
  int gear_dir = digitalRead(8);
  int gear_park = digitalRead(7);
  data.dir = gear_dir;
  // Serial.println(gear_dir);
  // Serial.println(gear_park);
  Serial.println(gasReading);
  int turn_val = 0;
  if (brakeReading > 50){
    digitalWrite(5, HIGH);
    data.throttle = 0;
    
  }
  else{
    digitalWrite(5, LOW);
    data.throttle = map(gasReading,0,1023,0,255);
    
  }
  if(gear_park){
    data.throttle = 0;
  }
  if ((gasReading > 50 && gasReading <= 250))
    {
      digitalWrite(4, HIGH);
      digitalWrite(3, LOW);

    } else if (gasReading >250 && gasReading <=450) {
      digitalWrite(4, LOW);
      digitalWrite(3, HIGH);
    } else if (gasReading > 450) {
      digitalWrite(3, HIGH);
      digitalWrite(4, HIGH);
    } else{
      digitalWrite(3, LOW);
      digitalWrite(4, LOW);
    }

  int bit1 = analogRead(first);
  int bit2 = analogRead(second);
  int bit3 = analogRead(third);
  int bit4 = analogRead(fourth);
  int bit5 = digitalRead(2);
  int bit6 = digitalRead(6);

  if (bit1 > 500){
    turn_val = turn_val + 1;
  }
  if (bit2 >500){
    turn_val = turn_val + 2;
  }
  if (bit3 >500){
    turn_val = turn_val +4;
  }
  if (bit4 > 500){
    turn_val = turn_val + 8;
  }
  if (bit5 >0){
    turn_val = turn_val + 16;
    }
  if (bit6 >0){
    turn_val = turn_val + 32;
  }

  
  // 9 to 0 -> left
  // 15 to 10 -> right
  data.turn = turn_val*4;
  // Serial.println(data.turn);
  // Serial.println(data.throttle);
  radio.write(&data,sizeof(Signal));
  delay(50);
}