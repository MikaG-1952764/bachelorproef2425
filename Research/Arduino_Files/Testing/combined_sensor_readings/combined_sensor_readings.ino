#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <Wire.h>
#include "MAX30105.h"
#include "spo2_algorithm.h"

// Sensor & BLE Objects
MAX30105 particleSensor;
BLEServer *pServer = NULL;
BLECharacteristic *pDataCharacteristic = NULL;
BLECharacteristic *pCommandCharacteristic = NULL;

// BLE Service & Characteristics
#define SERVICE_UUID        "180C" 
#define DATA_CHAR_UUID      "2A6E"  // For sending HR, SpO2, GSR data
#define COMMAND_CHAR_UUID   "2A6F"  // For receiving start/stop commands

const int gsrPin = A2;
int analogPin = A0;             // BITalino EMG sensor connected to analog 
              // outside leads to ground and +3.3V
int val = 0;                    // variabe to store the value read

bool measuring = false;
bool measuringHeart = false;
bool measuringSpo2 = false;
bool measuringGSR = false;
bool measuringBreathing = false;
bool breathingMeasurementStarted = false;

#if defined(__AVR_ATmega328P__) || defined(__AVR_ATmega168__)
uint16_t irBuffer[100], redBuffer[100];
#else
uint32_t irBuffer[100], redBuffer[100];
#endif

int32_t bufferLength, spo2, heartRate;
int8_t validSPO2, validHeartRate;
int gsrAverage = 0;
int breathsPerMinute = 0;

// BLE Server Callback (to detect app connection)
class MyServerCallbacks : public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
        Serial.println("App connected.");
    }
    void onDisconnect(BLEServer* pServer) {
        Serial.println("App disconnected.");
        measuring = false;
        measuringHeart = false;
        measuringSpo2 = false;
        measuringGSR = false;
        measuringBreathing = false;// Stop measuring if app disconnects
    }
};

// BLE Command Callback (to start/stop measuring)
class MyCommandCallbacks : public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCharacteristic) {
        std::string command = pCharacteristic->getValue();
        if (command == "START") {
            measuring = true;
            Serial.println("Measurement Started!");
        } else if (command == "START HEART"){
            measuringHeart = true;
            Serial.println("Heart measurement Started!");
        }
        else if (command == "START SPO2"){
            measuringSpo2 = true;
            Serial.println("SPO2 measurement Started!");
        }
        else if (command == "START GSR"){
            measuringGSR = true;
            Serial.println("GSR measurement Started!");
        } else if (command == "START BREATHING"){
            measuringBreathing = true;
            Serial.println("Breathing measurement Started!");
        }
        else if (command == "STOP") {
            measuring = false;
            measuringHeart = false;
            measuringSpo2 = false;
            measuringGSR = false;
            measuringBreathing = false;
            Serial.println("Measurement Stopped!");
        }
    }
};

void setup() {
    Serial.begin(115200);
    delay(2000);

    // Initialize BLE
    BLEDevice::init("Nano ESP32");
    pServer = BLEDevice::createServer();
    pServer->setCallbacks(new MyServerCallbacks());

    BLEService *pService = pServer->createService(SERVICE_UUID);

    // Data characteristic (HR, SpO2, GSR)
    pDataCharacteristic = pService->createCharacteristic(DATA_CHAR_UUID, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY|
    BLECharacteristic::PROPERTY_WRITE);

    // Command characteristic (Start/Stop)
    pCommandCharacteristic = pService->createCharacteristic(COMMAND_CHAR_UUID, BLECharacteristic::PROPERTY_WRITE);
    pCommandCharacteristic->setCallbacks(new MyCommandCallbacks());

    pService->start();
    pServer->getAdvertising()->start();
    Serial.println("BLE Ready. Waiting for commands...");

    setupHeartRateSPO2Sensor();
}

void loop() {
    if (measuring) {
        readingsHeartRateSPO2Sensor();
        readingsGSRSensor();
        breathingMeasurementStarted = true;
        readingBreathSensor();
        breathingMeasurementStarted = false;
        sendDataOverBluetooth();
    }
    if (measuringHeart){
        readingsHeartRateSPO2Sensor();
        sendDataOverBluetooth();
    } 
    if (measuringSpo2){
        readingsHeartRateSPO2Sensor();
        sendDataOverBluetooth();
    } 
    if (measuringGSR){
        readingsGSRSensor();
        sendDataOverBluetooth();
    }
    if(measuringBreathing && !breathingMeasurementStarted){
        breathingMeasurementStarted = true;
        readingBreathSensor();
        sendDataOverBluetooth();
        breathingMeasurementStarted = false;
    }
    delay(100);
}

void sendDataOverBluetooth() {
    String data = "HR:" + String(heartRate) + " SpO2:" + String(spo2) + " GSR:" + String(gsrAverage) + " Breathing:" + String(breathsPerMinute);
    Serial.println(data);  // Print data to the serial monitor for debugging
    pDataCharacteristic->setValue(data.c_str());
    pDataCharacteristic->notify();
}

// Heart Rate & SpO2 Setup
void setupHeartRateSPO2Sensor() {
    if (!particleSensor.begin(Wire, I2C_SPEED_FAST)) {
        Serial.println("MAX30105 not found.");
        while (1);
    }
    particleSensor.setup(200, 8, 2, 1000, 411, 16384);
}

// Heart Rate & SpO2 Readings
void readingsHeartRateSPO2Sensor() {
    bufferLength = 100;
    Serial.println("Heart & spo2 measuring ...");
    for (byte i = 0; i < bufferLength; i++) {
        while (!particleSensor.available()) particleSensor.check();
        redBuffer[i] = particleSensor.getRed();
        irBuffer[i] = particleSensor.getIR();
        particleSensor.nextSample();
    }
    maxim_heart_rate_and_oxygen_saturation(irBuffer, bufferLength, redBuffer, &spo2, &validSPO2, &heartRate, &validHeartRate);
    measuringHeart = false;
    measuringSpo2 = false;
}

// GSR Sensor Readings
void readingsGSRSensor() {
    long sum = 0;
    Serial.println("GSR measuring ...");
    for (int i = 0; i < 40; i++) {
        sum += analogRead(gsrPin);
        delay(5);
    }
    gsrAverage = sum / 40;
    measuringGSR = false;
}

void readingBreathSensor() {
  unsigned long startTime = millis(); // get the current time
  unsigned long duration = 60000;     // 60 seconds in milliseconds
  int lastVal = 0;
  bool rising = false;
  int breathCount = 0;

  const int threshold = 30 // -> might need to try threshold between 45-60 // adjust this based on your sensor range
  const int analogPin = A0; // make sure this matches your setup

  while (millis() - startTime < duration) {
    int val = analogRead(analogPin);  // read the input pin

    // Optional: basic smoothing
    static int smoothed = 0;
    smoothed = (smoothed * 3 + val) / 4;

    if (smoothed > lastVal + threshold) {
      rising = true;
    }

    if (rising && smoothed < lastVal - threshold) {
      breathCount++;
      rising = false;
    }

    lastVal = smoothed;

    Serial.println(val); // For visualization/debug
    delay(50);           // 20 Hz sampling
  }

  breathsPerMinute = breathCount;
  Serial.print("Breaths per minute: ");
  Serial.println(breathsPerMinute);

  Serial.println("Measurement complete.");
  measuringBreathing = false;
  delay(10000);
}

