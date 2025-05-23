import 'package:flutter/material.dart';

class SensorData extends ChangeNotifier {
  int heartRate;
  int spo2;
  int gsr;
  int breathingRate;

  SensorData(
      {required this.heartRate,
      required this.spo2,
      required this.gsr,
      required this.breathingRate});

  void setData(int newHR, int newSpo2, int newGSR, newBreathingRate) {
    heartRate = newHR;
    spo2 = newSpo2;
    gsr = newGSR;
    breathingRate = newBreathingRate;
    notifyListeners();
  }

  void setHeartData(int newHR) {
    heartRate = newHR;
    gsr = gsr;
    spo2 = spo2;
    breathingRate = breathingRate;
    notifyListeners();
  }

  void setSpo2Data(int newSpo2) {
    spo2 = newSpo2;
    gsr = gsr;
    heartRate = heartRate;
    breathingRate = breathingRate;
    notifyListeners();
  }

  void setGSRData(int newGSR) {
    gsr = newGSR;
    heartRate = heartRate;
    spo2 = spo2;
    breathingRate = breathingRate;
    notifyListeners();
  }

  void setBreathingRateData(int newBreathingRate) {
    breathingRate = newBreathingRate;
    heartRate = heartRate;
    spo2 = spo2;
    gsr = gsr;
    notifyListeners();
  }
}
