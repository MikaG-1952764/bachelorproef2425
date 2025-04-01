import 'package:flutter/material.dart';

class SensorData extends ChangeNotifier {
  double heartRate;
  double spo2;
  double gsr;

  SensorData({required this.heartRate, required this.spo2, required this.gsr});

  void setData(double newHR, double newSpo2, double newGSR) {
    heartRate = newHR;
    if (newSpo2 >= 0 && newSpo2 <= 100) {
      spo2 = newSpo2;
    } else {
      spo2 = spo2;
    }
    spo2 = newSpo2;
    gsr = newGSR;
    notifyListeners();
  }

  void setHeartData(double newHR) {
    heartRate = newHR;
    gsr = gsr;
    spo2 = spo2;
    notifyListeners();
  }

  void setSpo2Data(double newSpo2) {
    if (newSpo2 >= 0 && newSpo2 <= 100) {
      spo2 = newSpo2;
    } else {
      spo2 = spo2;
    }
    gsr = gsr;
    heartRate = heartRate;
    notifyListeners();
  }

  void setGSRData(double newGSR) {
    gsr = newGSR;
    heartRate = heartRate;
    spo2 = spo2;
    notifyListeners();
  }
}
