// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:permission_handler/permission_handler.dart';
import 'package:stress_measurement_app/Models/database.dart';
import 'dart:async';
import '../Models/sensor_data.dart';

class Bluetooth with ChangeNotifier {
  fbp.BluetoothDevice? connectedDevice;
  final List<fbp.ScanResult> _scanResults = [];
  final StreamController<List<fbp.ScanResult>> _scanResultsStreamController =
      StreamController<List<fbp.ScanResult>>.broadcast();
  late final AppDatabase appDatabase;

  void setDatabase(AppDatabase database) {
    appDatabase = database;
  }

  AppDatabase getDatabase() {
    return appDatabase;
  }

  bool isMeasuring = false; // Flag to track measurement state
  String newData = "all"; // Variable to track the type of data being read

  // Expose the stream to listen to scan results
  Stream<List<fbp.ScanResult>> get scanResultsStream =>
      _scanResultsStreamController.stream;

  Future<void> requestPermissions() async {
    if (await Permission.bluetooth.isDenied) {
      await Permission.bluetooth.request();
    }

    if (await Permission.location.isDenied) {
      await Permission.location.request();
    }

    if (await Permission.bluetoothConnect.isDenied) {
      await Permission.bluetoothConnect.request();
    }

    if (await Permission.bluetoothScan.isDenied) {
      await Permission.bluetoothScan.request();
    }
  }

  Future<void> startScan() async {
    // Request permissions before proceeding
    await requestPermissions();

    bool isBluetoothOn =
        fbp.FlutterBluePlus.adapterState == fbp.BluetoothAdapterState.on;
    if (!isBluetoothOn) {
      await fbp.FlutterBluePlus.turnOn();
    }

    // Start scanning with a higher scan mode for better responsiveness
    await fbp.FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 20),
      androidScanMode:
          fbp.AndroidScanMode.lowLatency, // Try using lowLatency mode
    );

    // Log Bluetooth state
    fbp.FlutterBluePlus.adapterState.listen((state) {
      print('Bluetooth state: $state');
    });

    // Listen for scan results and update the Stream
    fbp.FlutterBluePlus.scanResults.listen((results) {
      // Emit updated scan results every time we get new data
      _scanResults.clear();
      _scanResults.addAll(results);
      _scanResultsStreamController.add(_scanResults); // Emit updated results
      print("Found ${results.length} devices.");
    });
  }

  void stopScan() {
    fbp.FlutterBluePlus.stopScan();
  }

  Future<void> connectToDevice(fbp.BluetoothDevice device) async {
    try {
      stopScan(); // Stop scanning when connecting
      print('Attempting to connect to device: ${device.platformName}');
      await device.connect();
      print('Connected to ${device.platformName}');
      Future.delayed(const Duration(seconds: 20));
      connectedDevice = device;
      print('Connected to ${device.platformName}');
      // Discover available services & characteristics
      List<fbp.BluetoothService> services =
          await connectedDevice!.discoverServices();
      Future.delayed(const Duration(seconds: 2));
      await device.requestMtu(23);
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString().toLowerCase().contains("2a6e")) {
            // Find correct characteristic
            print("Found characteristic: ${characteristic.uuid}");
            if (characteristic.properties.notify) {
              characteristic.lastValueStream.listen((value) {
                if (value.isEmpty) {
                  print("No data received");
                } else {
                  String receivedData = String.fromCharCodes(value);
                  print("Received BLE Data: $receivedData");

                  RegExp regex = RegExp(
                      r'HR:\s*([\d.]+), SpO2:\s*([\d.]+), GSR:\s*([\d.]+), Breathing:\s*([\d.]+)');
                  var match = regex.firstMatch(receivedData);

                  if (match != null) {
                    int hr = int.tryParse(match.group(1)!) ?? 0;
                    int spo2 = int.tryParse(match.group(2)!) ?? 0;
                    int gsr = int.tryParse(match.group(3)!) ?? 0;
                    int breathingRate = int.tryParse(match.group(4)!) ?? 0;

                    SensorData sensorData = SensorData(
                        heartRate: hr,
                        spo2: spo2,
                        gsr: gsr,
                        breathingRate: breathingRate);
                    print(
                        "Parsed SensorData: HR=${sensorData.heartRate}, SpO2=${sensorData.spo2}, GSR=${sensorData.gsr}");
                  }
                }
              });
            }
          }
        }
      }
    } catch (e) {
      print('Connection failed: $e');
    }
  }

  Future<void> startMeasurement(SensorData sensorData) async {
    if (connectedDevice == null) {
      print("No device connected");
      notifyListeners();
    }

    List<fbp.BluetoothService> services =
        await connectedDevice!.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString().toLowerCase().contains("2a6f")) {
          // Command Characteristic
          print("Sending START command...");
          await characteristic.write(utf8.encode("START"),
              withoutResponse: false);
          isMeasuring = true;
          print("Measurement started");
          readData(sensorData);
          isMeasuring = false; // Stop the measurement after collecting data
          notifyListeners(); // Stop the measurement after collecting data
        }
      }
    }
    print("START command characteristic not found");
  }

  Future<void> startHeartMeasurement(SensorData sensorData) async {
    if (connectedDevice == null) {
      print("No device connected");
      notifyListeners();
    }

    List<fbp.BluetoothService> services =
        await connectedDevice!.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString().toLowerCase().contains("2a6f")) {
          // Command Characteristic
          print("Sending START HEART command...");
          await characteristic.write(utf8.encode("START HEART"),
              withoutResponse: false);
          isMeasuring = true;
          newData = "HR"; // Set the newData variable to "HR"
          print("Measurement started");
          readData(
            sensorData,
          );
          isMeasuring = false;
          notifyListeners();
        }
      }
    }
    print("START command characteristic not found");
  }

  Future<void> stopMeasurement() async {
    if (connectedDevice == null) {
      print("No device connected");
      notifyListeners();
    }

    List<fbp.BluetoothService> services =
        await connectedDevice!.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString().toLowerCase().contains("2a6f")) {
          // Command Characteristic
          print("Sending STOP command...");
          await characteristic.write(utf8.encode("STOP"),
              withoutResponse: false);
          isMeasuring = false;
          newData = "HR"; // Set the newData variable to "HR"
          print("Measurement stopped");
          notifyListeners();
        }
      }
    }
    print("STOP command characteristic not found");
  }

  Future<void> startSpo2Measurement(SensorData sensorData) async {
    if (connectedDevice == null) {
      print("No device connected");
      notifyListeners();
    }

    List<fbp.BluetoothService> services =
        await connectedDevice!.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString().toLowerCase().contains("2a6f")) {
          // Command Characteristic
          print("Sending START SPO2 command...");
          await characteristic.write(utf8.encode("START SPO2"),
              withoutResponse: false);
          isMeasuring = true;
          newData = "SpO2"; // Set the newData variable to "SpO2"
          print("Measurement started");
          print("In spo2 meaurement");
          readData(
            sensorData,
          );
          isMeasuring = false;
          notifyListeners();
        }
      }
    }
    print("START command characteristic not found");
  }

  Future<void> startGSRMeasurement(SensorData sensorData) async {
    if (connectedDevice == null) {
      print("No device connected");
      notifyListeners();
    }

    List<fbp.BluetoothService> services =
        await connectedDevice!.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString().toLowerCase().contains("2a6f")) {
          // Command Characteristic
          print("Sending START GSR command...");
          await characteristic.write(utf8.encode("START GSR"),
              withoutResponse: false);
          isMeasuring = true;
          newData = "GSR"; // Set the newData variable to "GSR"
          print("Measurement started");
          readData(sensorData);
          isMeasuring = false;
          notifyListeners();
        }
      }
    }
    print("START command characteristic not found");
  }

  Future<void> startBreathingMeasurement(SensorData sensorData) async {
    if (connectedDevice == null) {
      print("No device connected");
      notifyListeners();
    }

    List<fbp.BluetoothService> services =
        await connectedDevice!.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString().toLowerCase().contains("2a6f")) {
          // Command Characteristic
          print("Sending START BREATHING command...");
          await characteristic.write(utf8.encode("START BREATHING"),
              withoutResponse: false);
          isMeasuring = true;
          newData = "Breathing"; // Set the newData variable to "HR"
          print("Measurement started");
          readData(
            sensorData,
          );
          isMeasuring = false;
          notifyListeners();
        }
      }
    }
    print("START command characteristic not found");
  }

  int receivedDataCount = 0; // Counter to track received data
  final int maxReadings = 1; // Adjust this number based on your needs

  Future<void> readData(SensorData sensorData) async {
    if (connectedDevice == null || !isMeasuring) {
      print("No device found or measurement not active");
      return;
    }

    List<fbp.BluetoothService> services =
        await connectedDevice!.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString().toLowerCase().contains("2a6e")) {
          // Data Characteristic
          if (characteristic.properties.notify) {
            await characteristic.setNotifyValue(true);

            characteristic.lastValueStream.listen((value) async {
              if (value.isEmpty) {
                print("No data received");
                return;
              }

              String receivedData = String.fromCharCodes(value);
              print("Notification Data: $receivedData");

              // Parse data if it follows "HR: X, SpO2: Y, GSR: Z"
              List<String> parts = receivedData.split(' ');
              if (parts.length == 4) {
                int hr = int.tryParse(parts[0].split(':')[1].trim()) ?? 0;
                int spo2 = int.tryParse(parts[1].split(':')[1].trim()) ?? 0;
                int gsr = int.tryParse(parts[2].split(':')[1].trim()) ?? 0;
                int breathingRate =
                    int.tryParse(parts[3].split(':')[1].trim()) ?? 0;

                // Update SensorData based on the new data type
                switch (newData) {
                  case "HR":
                    print("in case hr");
                    if (hr != -999) {
                      sensorData.setHeartData(hr);
                      appDatabase.insertHeartRate(hr);
                    }
                    // Save heart rate to database
                    newData =
                        "all"; // Reset to all after heart rate measurement
                    break;
                  case "SpO2":
                    print("in case spo2");
                    if (spo2 != -999) {
                      sensorData.setSpo2Data(spo2);
                      appDatabase.insertSpo2(spo2);
                    }
                    newData = "all"; // Reset to all after SpO2 measurement
                    break;
                  case "GSR":
                    print("in case gsr");
                    sensorData.setGSRData(gsr);
                    appDatabase.insertGSR(gsr);
                    newData = "all"; // Reset to all after GSR measurement
                    break;
                  case "Breathing":
                    print("in case breathing");
                    sensorData.setBreathingRateData(breathingRate);
                    appDatabase.insertRespitoryRate(breathingRate);
                    newData = "all"; // Reset to all after breathing measurement
                    break;
                  default:
                    print("in case all");
                    sensorData.setData(hr, spo2, gsr, breathingRate);
                    appDatabase.insertHeartRate(hr);
                    appDatabase.insertSpo2(spo2);
                    appDatabase.insertGSR(gsr);
                    appDatabase.insertRespitoryRate(breathingRate);
                    break;
                }

                print(
                    "Parsed SensorData: HR=${sensorData.heartRate}, SpO2=${sensorData.spo2}, GSR=${sensorData.gsr}, BreathingRate=${sensorData.breathingRate}");
              }
              // Increment received data count
              receivedDataCount++;
              if (receivedDataCount >= maxReadings) {
                value.clear();

                print("Max readings received. Stopping measurement.");

                // Stop notifications before stopping measurement
                await characteristic.setNotifyValue(false);
                receivedDataCount = 0;
                print("Received readings: $receivedDataCount");
              }
            });
          }
        }
      }
    }
  }

  Future<SensorData> readSingleData(SensorData sensorData) async {
    if (connectedDevice == null) {
      print("No device found or measurement not active");
      return sensorData;
    }

    final completer = Completer<SensorData>();

    List<fbp.BluetoothService> services =
        await connectedDevice!.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString().toLowerCase().contains("2a6e")) {
          // Data Characteristic
          if (characteristic.properties.notify) {
            await characteristic.setNotifyValue(true);

            characteristic.lastValueStream.listen((value) async {
              if (value.isEmpty) {
                print("No data received");
                return;
              }

              String receivedData = String.fromCharCodes(value);
              print("Notification Data: $receivedData");

              // Parse data if it follows "HR: X, SpO2: Y, GSR: Z"
              List<String> parts = receivedData.split(' ');
              if (parts.length == 4) {
                int hr = int.tryParse(parts[0].split(':')[1].trim()) ?? 0;
                int spo2 = int.tryParse(parts[1].split(':')[1].trim()) ?? 0;
                int gsr = int.tryParse(parts[2].split(':')[1].trim()) ?? 0;
                int breathingRate =
                    int.tryParse(parts[3].split(':')[1].trim()) ?? 0;

                sensorData.setData(hr, spo2, gsr, breathingRate);

                print(
                    "Parsed SensorData: HR=${sensorData.heartRate}, SpO2=${sensorData.spo2}, GSR=${sensorData.gsr}");
                completer
                    .complete(sensorData); // Complete when data is available
              }
              value.clear(); // Clear the value to prevent multiple triggers
            });

            // Optional timeout to prevent hanging forever
            Future.delayed(const Duration(seconds: 10), () {
              if (!completer.isCompleted) {
                completer.complete(sensorData); // Complete even if no data
              }
            });

            return completer.future; // Wait for the result before continuing
          }
        }
      }
    }

    return sensorData; // Return the sensorData if no suitable characteristic is found
  }

  Future<int> getAverageHeartRate() async {
    if (connectedDevice == null) {
      print("No device connected");
      notifyListeners();
      return 0;
    }

    SensorData sensorData =
        SensorData(heartRate: 0, spo2: 0, gsr: 0, breathingRate: 0);

    List<fbp.BluetoothService> services =
        await connectedDevice!.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString().toLowerCase().contains("2a6f")) {
          int validMeasurements = 0;
          List<int> heartRateValues = [];
          while (validMeasurements < 10) {
            print("Sending START HEART command...");
            await characteristic.write(utf8.encode("START HEART"),
                withoutResponse: false);
            print("Measurement started");

            sensorData.setData(0, 0, 0, 0);
            // Wait for the data to come back before proceeding
            SensorData data = await readSingleData(sensorData);

            if (data.heartRate > 20 && data.heartRate < 180) {
              validMeasurements++;
              heartRateValues.add(data.heartRate);
              print(
                  "Valid heart rate data received: ${data.heartRate}, $validMeasurements");
            } else {
              print("Invalid heart rate data received: ${data.heartRate}");
            }

            await Future.delayed(const Duration(
                seconds: 1)); // Wait 1 second before next attempt
          }
          stopMeasurement(); // Stop the measurement after collecting data
          // Return the average after collecting enough valid data
          return (heartRateValues.reduce((a, b) => a + b) /
                  heartRateValues.length)
              .round();
        }
      }
    }

    print("START command characteristic not found");
    throw Exception("Unable to calculate average heart rate");
  }

  Future<int> getRestingRespiration() async {
    if (connectedDevice == null) {
      print("No device connected");
      notifyListeners();
      return 0;
    }

    SensorData sensorData =
        SensorData(heartRate: 0, spo2: 0, gsr: 0, breathingRate: 0);

    List<fbp.BluetoothService> services =
        await connectedDevice!.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString().toLowerCase().contains("2a6f")) {
          int validMeasurements = 0;
          SensorData endData =
              SensorData(heartRate: 0, spo2: 0, gsr: 0, breathingRate: 0);
          while (validMeasurements < 1) {
            print("Sending START BREATHING command...");
            await characteristic.write(utf8.encode("START BREATHING"),
                withoutResponse: false);
            print("Measurement started");

            sensorData.setData(0, 0, 0, 0);
            // Wait for the data to come back before proceeding
            await Future.delayed(const Duration(seconds: 61));
            SensorData data = await readSingleData(sensorData);

            if (data.breathingRate > 4 && data.breathingRate < 18) {
              validMeasurements++;
              endData = data;
              print(
                  "Valid respiration data received: ${data.heartRate}, $validMeasurements");
              break;
            } else {
              print("Invalid respiration data received: ${data.breathingRate}");
            }

            await Future.delayed(const Duration(seconds: 1));
            // Wait 1 second before next attempt
          }
          stopMeasurement(); // Stop the measurement after collecting data
          // Return the average after collecting enough valid data
          return endData.breathingRate;
        }
      }
    }
    print("START command characteristic not found");
    throw Exception("Unable to measure breathing rate");
  }

  Future<int> getAverageGSR() async {
    if (connectedDevice == null) {
      print("No device connected");
      notifyListeners();
      return 0;
    }

    SensorData sensorData =
        SensorData(heartRate: 0, spo2: 0, gsr: 0, breathingRate: 0);

    List<fbp.BluetoothService> services =
        await connectedDevice!.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString().toLowerCase().contains("2a6f")) {
          int validMeasurements = 0;
          List<int> GSRValues = [];
          while (validMeasurements < 10) {
            print("Sending START GSR command...");
            await characteristic.write(utf8.encode("START GSR"),
                withoutResponse: false); // Set the newData variable to "GSR"
            print("Measurement started");

            sensorData.setData(0, 0, 0, 0);
            // Wait for the data to come back before proceeding
            SensorData data = await readSingleData(sensorData);

            if (data.gsr >= 0 && data.gsr < 3000) {
              validMeasurements++;
              GSRValues.add(data.gsr);
              print("Valid gsr data received: ${data.gsr}, $validMeasurements");
            } else {
              print("Invalid gsr data received: ${data.gsr}");
            }

            await Future.delayed(const Duration(
                seconds: 1)); // Wait 1 second before next attempt
          }
          stopMeasurement();
          // Return the average after collecting enough valid data
          return (GSRValues.reduce((a, b) => a + b) / GSRValues.length).round();
        }
      }
    }

    print("START command characteristic not found");
    throw Exception("Unable to calculate average gsr");
  }
}
