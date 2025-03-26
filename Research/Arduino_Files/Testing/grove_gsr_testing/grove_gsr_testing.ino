const int gsr=A2;
int sensorValue=0;
int gsrAverage=0;

void setup(){
  Serial.begin(9600);
  delay(2000);
}

void loop(){
  long sum=0;
  for(int i=0; i<10; i++){
    sensorValue=analogRead(gsr);
    sum+=sensorValue;
    delay(5);
  }
  gsrAverage=sum/10;
  //Serial.print("GSR average: ");
  Serial.println(gsrAverage);
  delay(500);
}