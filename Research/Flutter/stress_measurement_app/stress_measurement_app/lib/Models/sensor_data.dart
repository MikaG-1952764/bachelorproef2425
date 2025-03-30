import 'package:flutter/material.dart';

class SensorData extends ChangeNotifier {
  double heartRate;
  double spo2;
  double gsr;

  SensorData({required this.heartRate, required this.spo2, required this.gsr});

  void setData(double newHR, double newSpo2, double newGSR) {
    heartRate = newHR;
    spo2 = newSpo2;
    gsr = newGSR;
    notifyListeners();
  }

  void setSHeartData(double newHR) {
    heartRate = newHR;
    notifyListeners();
  }

  void setSpo2Data(double newSpo2) {
    spo2 = newSpo2;
    notifyListeners();
  }

  void setGSRData(double newGSR) {
    gsr = newGSR;
    notifyListeners();
  }
}
