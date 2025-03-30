import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:stress_measurement_app/Models/sensor_data.dart';
import 'package:stress_measurement_app/Models/bluetooth.dart';
import 'UI/homescreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final Bluetooth bluetooth = Bluetooth();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SensorData(heartRate: 0, spo2: 0, gsr: 0),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(bluetooth: bluetooth),
      ),
    );
  }
}
