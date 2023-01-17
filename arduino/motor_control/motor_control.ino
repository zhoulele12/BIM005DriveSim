#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>

#define PIN_Motor_PWMA 5
#define PIN_Motor_PWMB 6
#define PIN_Motor_BIN_1 8
#define PIN_Motor_AIN_1 7
#define PIN_Motor_STBY 3

RF24 radio(9,10);
struct Signal{
  byte throttle;
  byte turn;
  byte dir;
};
int throttle;
int turn;

Signal data;

const uint64_t pipeIn = 0xE9E8F0F0E1LL;

void setup() {
  Serial.begin(9600);
  radio.begin();
  radio.openReadingPipe(1,pipeIn);
  radio.startListening();
  pinMode(PIN_Motor_PWMA, OUTPUT);
  pinMode(PIN_Motor_PWMB, OUTPUT);
  pinMode(PIN_Motor_AIN_1, OUTPUT);
  pinMode(PIN_Motor_BIN_1, OUTPUT);
  pinMode(PIN_Motor_STBY, OUTPUT);
  pinMode(10,OUTPUT);

  delay(2000);
  digitalWrite(PIN_Motor_STBY, HIGH);
}


void recvData()
{
  while (radio.available()) {
    radio.read(&data,sizeof(Signal));   
  }
}

void loop() {
  recvData();
  throttle = data.throttle;
  turn = data.turn;
  Serial.println("throttle: ");
  Serial.println(throttle);
  Serial.println("turn: ");
  Serial.println(turn);
  Serial.println("dir: ");
  Serial.println(data.dir);
 
  int velocity = throttle;
  bool turn_dir = (turn - 128) >0;
  float turn_percent = 2.0*(float(turn) - 128.0)/128.0;
//  Serial.println("dir: ");
//  Serial.println(turn_dir);
//  Serial.println("percent: ");
//  Serial.println(turn_percent);
//  Serial.println(round(float(abs(velocity))*(1.0-turn_percent)));
  if(data.dir==0){
    digitalWrite(PIN_Motor_AIN_1, HIGH);
    digitalWrite(PIN_Motor_BIN_1, HIGH);
  } else {
    digitalWrite(PIN_Motor_AIN_1, LOW);
    digitalWrite(PIN_Motor_BIN_1, LOW);
  }
//  analogWrite(PIN_Motor_PWMA, abs(velocity));
//  analogWrite(PIN_Motor_PWMB, abs(velocity));
  if((turn - 128) >0){ //right turn
    analogWrite(PIN_Motor_PWMA, round(float(abs(velocity))*(1.0-turn_percent)));
    analogWrite(PIN_Motor_PWMB, abs(velocity));
  } else if((turn - 128) <=0) {
    analogWrite(PIN_Motor_PWMA, abs(velocity));
    analogWrite(PIN_Motor_PWMB, round(float(abs(velocity))*(1.0+turn_percent)));//plus here cuz turn_percent is negative
    
  }
  delay(50);
  
}