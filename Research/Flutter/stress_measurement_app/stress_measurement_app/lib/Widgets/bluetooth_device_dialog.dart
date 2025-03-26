import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../Models/bluetooth.dart';

class BluetoothScanPage extends StatefulWidget {
  const BluetoothScanPage({super.key, required this.bluetoothService});
  final Bluetooth bluetoothService;
  @override
  _BluetoothScanPageState createState() => _BluetoothScanPageState();
}

class _BluetoothScanPageState extends State<BluetoothScanPage> {
  bool isScanning = false;
  bool isConnecting = false;

  Bluetooth get bluetoothService => widget.bluetoothService;

  @override
  void initState() {
    super.initState();
  }

  // Function to toggle scanning
  void toggleScan() async {
    if (isScanning) {
      setState(() {
        isScanning = false;
      });
      bluetoothService.stopScan();
    } else {
      setState(() {
        isScanning = true;
      });
      await bluetoothService.startScan();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bluetooth Scan"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: toggleScan, // Toggle scan on button press
              child: Text(isScanning ? "Stop Scanning" : "Start Scanning"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<ScanResult>>(
                stream: bluetoothService.scanResultsStream, // Listen to scan results stream
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No devices found"));
                  }

                  final scanResults = snapshot.data!;
                  return ListView.builder(
                    itemCount: scanResults.length,
                    itemBuilder: (context, index) {
                      ScanResult result = scanResults[index];
                      return ListTile(
                        title: Text(result.device.platformName.isNotEmpty
                            ? result.device.platformName
                            : "Unknown Device"),
                        subtitle: Text(result.device.remoteId.toString()),
                        onTap: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false, // Prevent dismissing by tapping outside
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("CONNECTION"),
                                content: Text("Connecting to ${result.device.platformName}..."),
                              );
                            },
                          );

                          // Attempt to connect to the device
                          setState(() {
                            isConnecting = true;
                          });
                          await bluetoothService.connectToDevice(result.device);

                          // Close the dialog once the connection is successful
                          if (isConnecting) {
                            Navigator.pop(context); // Close the dialog
                          }

                          // Show the connection dialog after the device is connected
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("CONNECTION"),
                                content: Text("Device ${result.device.platformName} is connected."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context); // Close the dialog
                                    },
                                    child: const Text("Close"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
