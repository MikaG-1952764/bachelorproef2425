import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:stress_measurement_app/Models/database.dart';
import 'package:stress_measurement_app/Models/sensor_data.dart';
import 'package:stress_measurement_app/Models/bluetooth.dart';
import 'package:stress_measurement_app/UI/user_selection.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final Bluetooth bluetooth = Bluetooth();
  final AppDatabase database = AppDatabase();

  @override
  Widget build(BuildContext context) {
    bluetooth.setDatabase(database);
    return ChangeNotifierProvider(
      create: (_) =>
          SensorData(heartRate: 0, spo2: 0, gsr: 0, breathingRate: 0),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: UserSelection(
          bluetooth: bluetooth,
        ),
      ),
    );
  }
}
