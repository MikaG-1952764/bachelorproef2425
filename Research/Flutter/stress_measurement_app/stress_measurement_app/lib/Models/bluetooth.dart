import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import '../Models/sensor_data.dart';

class Bluetooth with ChangeNotifier{
  fbp.BluetoothDevice? connectedDevice;
  final List<fbp.ScanResult> _scanResults = [];
  final StreamController<List<fbp.ScanResult>> _scanResultsStreamController =
      StreamController<List<fbp.ScanResult>>.broadcast();

  bool isMeasuring = false; // Flag to track measurement state
  
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

    bool isBluetoothOn = fbp.FlutterBluePlus.adapterState == fbp.BluetoothAdapterState.on;
    if (!isBluetoothOn) {
      await fbp.FlutterBluePlus.turnOn();
    }

    // Start scanning with a higher scan mode for better responsiveness
    await fbp.FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 20),
      androidScanMode: fbp.AndroidScanMode.lowLatency, // Try using lowLatency mode
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
      List<fbp.BluetoothService> services = await connectedDevice!.discoverServices();
      Future.delayed(const Duration(seconds: 2));
      await device.requestMtu(23);
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString().toLowerCase().contains("2a6e")) { // Find correct characteristic
            print("Found characteristic: ${characteristic.uuid}");
            if (characteristic.properties.notify) {
              characteristic.lastValueStream.listen((value) {
                if(value.isEmpty){
                  print("No data received");
                } else {
                  String receivedData = String.fromCharCodes(value);
                  print("Received BLE Data: $receivedData");

                  RegExp regex = RegExp(r'HR:\s*([\d.]+), SpO2:\s*([\d.]+), GSR:\s*([\d.]+)');
                  var match = regex.firstMatch(receivedData);

                  if (match != null) {
                    double hr = double.tryParse(match.group(1)!) ?? 0;
                    double spo2 = double.tryParse(match.group(2)!) ?? 0;
                    double gsr = double.tryParse(match.group(3)!) ?? 0;

                    SensorData sensorData = SensorData(heartRate: hr, spo2: spo2, gsr: gsr);
                    print("Parsed SensorData: HR=${sensorData.heartRate}, SpO2=${sensorData.spo2}, GSR=${sensorData.gsr}");}
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

    List<fbp.BluetoothService> services = await connectedDevice!.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString().toLowerCase().contains("2a6f")) { // Command Characteristic
          print("Sending START command...");
          await characteristic.write(utf8.encode("START"), withoutResponse: false);
          isMeasuring = true;
          print("Measurement started");
          readData(sensorData);
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

    List<fbp.BluetoothService> services = await connectedDevice!.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString().toLowerCase().contains("2a6f")) { // Command Characteristic
          print("Sending STOP command...");
          await characteristic.write(utf8.encode("STOP"), withoutResponse: false);
          isMeasuring = false;
          print("Measurement stopped");
          notifyListeners();
        }
      }
    }
    print("STOP command characteristic not found");
  }

int receivedDataCount = 0; // Counter to track received data
final int maxReadings = 1; // Adjust this number based on your needs

Future<void> readData(SensorData sensorData) async {
  if (connectedDevice == null || !isMeasuring) {
    print("No device found or measurement not active");
    return;
  }

  List<fbp.BluetoothService> services = await connectedDevice!.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString().toLowerCase().contains("2a6e")) { // Data Characteristic
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
              if (parts.length == 3) {
                double hr = double.tryParse(parts[0].split(':')[1].trim()) ?? 0;
                double spo2 = double.tryParse(parts[1].split(':')[1].trim()) ?? 0;
                double gsr = double.tryParse(parts[2].split(':')[1].trim()) ?? 0;

                sensorData.setData(hr, spo2, gsr);
                print("Parsed SensorData: HR=${sensorData.heartRate}, SpO2=${sensorData.spo2}, GSR=${sensorData.gsr}");
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
                stopMeasurement();
              }
            });
          }
        }
      }
    }
  }
}
