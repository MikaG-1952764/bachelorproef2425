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
    notifyListeners(); // Notify listeners that the data has changed
  }
}
