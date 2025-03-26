import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../Models/sensor_data.dart';

class SensorProvider extends ChangeNotifier {
  SensorData _data = SensorData(heartRate: 75, spo2: 98, gsr: 0.5);

  SensorData get data => _data;

  SensorProvider() {
    _startUpdating();
  }

  void _startUpdating() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _data = SensorData(
        heartRate: 70 + Random().nextInt(40).toDouble(), 
        spo2: 93 + Random().nextDouble() * 5,
        gsr: Random().nextDouble(),
      );
      notifyListeners();
    });
  }
}
