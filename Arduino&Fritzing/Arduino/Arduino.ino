// Declaration of global variables.
// Pin variable is constant and predefined (A0)
#define DIM 62 
float semitono = 1.0594;
float LA = 440;
float SI = LA*pow(semitono,2);
float DO = SI*pow(semitono,1);
float RE = DO*pow(semitono,2);
float MI = RE*pow(semitono,2);
float FA = MI*pow(semitono,1);
float SOL = FA*pow(semitono,2);
float melody[DIM] = {SOL/2,100,DO,100,MI,100,SOL,100,DO*2,100,MI*2,100,SOL*2,300,MI*2,300,
  LA/semitono,100,DO,100,MI/semitono,100,LA*2/semitono,100,DO*2,100,MI*2/semitono,100,LA*4/semitono,300,MI*2/semitono,300,
  SI/semitono,100,RE,100,FA,100,SI/semitono*2,100,RE*2,100,FA*2,100,SI/semitono*4,200,0,100,
  SI/semitono*4,50,0,50,SI/semitono*4,50,0,50,SI/semitono*4,50,0,50,DO*4,300};


const int sensorPin=A0;
int sensorOut;
float digital;
int threshold= 500;
// calibrationValue is the threshold value at which the warning LED turns on/off
// To be determined empirically
float calibrationValue=0;

int buzzerpin=2;
char stato;
int flag=0;

void setup() {
  // Open serial communication
  Serial.begin(9600);
  // Set warning LED pin (2) as OUTPUT and sensorPin (A0) as INPUT
  //pinMode(2, OUTPUT);
  pinMode(sensorPin, INPUT);
  // Being (2) a digital pin we can set it to HIGH (5V) or LOW (GND)
  // We want the warning LED off when the program starts
  //digitalWrite(2,LOW); 
  pinMode(buzzerpin, OUTPUT);
  // The piezoelectric element placed on pin8 is used as an acoustic alarm
}

void loop() {
  // LDR outputs a current (analog) so we read the voltage @ A0 on the 10k Ohm Resistance which is connected to GND
  // N.B.: analogRead converts the analog voltage to a digital signal [0~1023bit]
  sensorOut = analogRead(sensorPin);
  if (sensorOut > 500){
    sensorOut = 1023;
    delay(100);
  } 
  //If the sensor exits from the path an acoustic alarm starts
  else if (flag == 1) { 
      sensorOut = 0;
      tone(buzzerpin, SOL/2, 50);
      delay(50);
      tone(buzzerpin, 0, 50);
      delay(50);
  } else {
    sensorOut = 0;
    delay(100);
  }
  
  // Re-convert the digital values to voltage values [0~1023bit to 0~5V] (optional)
  digital = sensorOut * (5.0/1024.0);
  // Print on the serial monitor the output
   Serial.write(sensorOut);
  // Serial.println(sensorOut);

  // If the reading value is > calibrationValue (reflecting the black path) the warning LED stays OFF (LOW), otherwise it lights up
//  if (sensorOut > calibrationValue){
//    digitalWrite(2,LOW);
//  } else {
//    digitalWrite(2,HIGH);    
//  }

   if(Serial.available()>0){
      stato = Serial.read();
      if (stato == 'A'){
          flag = 1;
          tone(buzzerpin, SOL, 100);
          delay(100);
          tone(buzzerpin, DO*2, 300);
       }
       else if (stato == 'B'){
          flag = 0;
          playMusic(melody);         
       }
   }
 
}

void playMusic(float melody[]){
  for (int i=0; i<DIM; i+=2)
  {
    tone(buzzerpin, melody[i], melody[i+1]);
    delay(melody[i+1]);
  }
}
