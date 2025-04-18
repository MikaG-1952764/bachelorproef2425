import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stress_measurement_app/Models/database.dart';
import 'package:stress_measurement_app/Models/sensor_data.dart';
import 'package:stress_measurement_app/UI/configering_page.dart';
import 'package:stress_measurement_app/UI/user_selection.dart';
import 'package:stress_measurement_app/Widgets/sensor_cards_pager.dart';
import '../Widgets/stress_indicator.dart';
import '../Widgets/bluetooth_device_dialog.dart';
import '../Models/bluetooth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {super.key, required this.bluetooth, required this.isNewUser});

  final Bluetooth bluetooth;
  final bool isNewUser;

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double minHeartValue = -1.0;
  double maxHeartValue = -1.0;
  double minGSRValue = -1.0;
  double maxGSRValue = -1.0;

  void showBluetoothScanPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              BluetoothScanPage(bluetoothService: widget.bluetooth)),
    );
  }

  void navigateToConfiguringHeartPage(BuildContext context) async {
    // Navigate to the ConfiguringPage and wait for the result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const ConfiguringPage(configuringValue: "Heart Rate")),
    );

    // If result is not null, update the min and max values
    if (result != null) {
      setState(() {
        minHeartValue = result['min'];
        maxHeartValue = result['max'];
      });
    }
  }

  void navigateToConfiguringGSRPage(BuildContext context) async {
    // Navigate to the ConfiguringPage and wait for the result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const ConfiguringPage(configuringValue: "GSR")),
    );

    // If result is not null, update the min and max values
    if (result != null) {
      setState(() {
        minGSRValue = result['min'];
        maxGSRValue = result['max'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppDatabase database = widget.bluetooth.getDatabase();
    String currentUser = database.getCurrentUser();
    if (widget.isNewUser) {
      return homePageNewUser(context, widget.bluetooth);
    } else {
      return ChangeNotifierProvider.value(
        value: widget.bluetooth,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 148, 204, 250),
          appBar: AppBar(
            title: Text("Stress Monitoring of $currentUser"),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back), // Standard back arrow
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserSelection(
                            bluetooth: widget.bluetooth,
                          )), // Replace with your target page
                );
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.bluetooth),
                onPressed: () => showBluetoothScanPage(context),
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            child: ListView(
              children: [
                const SizedBox(height: 20),
                // Floating action button to start/stop measurement
                Consumer<Bluetooth>(
                  builder: (context, bluetooth, _) {
                    return FloatingActionButton(
                      child: bluetooth.isMeasuring
                          ? const Text("Measuring...")
                          : const Text("Start measurement"),
                      onPressed: () async {
                        if (bluetooth.connectedDevice == null) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: const Text("No Device Connected"),
                                    content: const Text(
                                        "Please connect to a device to start measurement"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("OK"),
                                      ),
                                    ],
                                  ));
                        } else if (bluetooth.isMeasuring) {
                          await bluetooth.stopMeasurement();
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: bluetooth.connectedDevice != null
                                        ? const Text(
                                            "Select parameters to measure")
                                        : const Text("No Device Connected"),
                                    content: bluetooth.connectedDevice != null
                                        ? const Text("")
                                        : const Text("No Device Connected"),
                                    actions: [
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Spacer(),
                                              Container(
                                                width: 100,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.blue,
                                                ),
                                                child: TextButton(
                                                  onPressed: () => {
                                                    bluetooth.startMeasurement(
                                                        Provider.of<SensorData>(
                                                            context,
                                                            listen: false)),
                                                    Navigator.pop(context),
                                                  },
                                                  child: const Text(
                                                    "All",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              Container(
                                                width: 100,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.blue,
                                                ),
                                                child: TextButton(
                                                  onPressed: () => {
                                                    bluetooth
                                                        .startHeartMeasurement(
                                                            Provider.of<
                                                                    SensorData>(
                                                                context,
                                                                listen: false)),
                                                    Navigator.pop(context),
                                                  },
                                                  child: const Text(
                                                    "Heart Rate",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              const Spacer(),
                                              Container(
                                                width: 100,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.blue,
                                                ),
                                                child: TextButton(
                                                  onPressed: () => {
                                                    bluetooth
                                                        .startSpo2Measurement(
                                                            Provider.of<
                                                                    SensorData>(
                                                                context,
                                                                listen: false)),
                                                    Navigator.pop(context),
                                                  },
                                                  child: const Text(
                                                    "Spo2",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              Container(
                                                width: 100,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.blue,
                                                ),
                                                child: TextButton(
                                                  onPressed: () => {
                                                    bluetooth
                                                        .startGSRMeasurement(
                                                            Provider.of<
                                                                    SensorData>(
                                                                context,
                                                                listen: false)),
                                                    Navigator.pop(context),
                                                  },
                                                  child: const Text(
                                                    "GSR",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ));
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Listen to the SensorData changes using Consumer
                Consumer<SensorData>(builder: (context, sensorData, _) {
                  return Column(
                    children: [
                      /*SizedBox(
                      width: 300,
                      height: 50,
                      child: FloatingActionButton(
                          child: const Text("Print data amount (debug)"),
                          onPressed: () async {
                            print(
                                "Heart rate database readings: ${await widget.bluetooth.getDatabase().getHeartRateCount()}");
                            print(
                                "GSR database readings: ${await widget.bluetooth.getDatabase().getGSRCount()}");
                            print(
                                "Spo2 database readings: ${await widget.bluetooth.getDatabase().getSpo2Count()}");
                          }),
                    ),
                    const SizedBox(height: 20),*/
                      SizedBox(
                        width: 300,
                        height: 60,
                        child: StressIndicator(sensorData.gsr),
                      ),
                      const SizedBox(height: 20),
                      SensorCardsPager(
                        minHeartValue: minHeartValue,
                        maxHeartValue: maxHeartValue,
                        minGSRValue: minGSRValue,
                        maxGSRValue: maxGSRValue,
                        sensorData: sensorData,
                        bluetooth: widget.bluetooth,
                        onHeartConfig: () =>
                            navigateToConfiguringHeartPage(context),
                        onGSRConfig: () =>
                            navigateToConfiguringGSRPage(context),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      );
    }
  }

  Scaffold homePageNewUser(BuildContext context, Bluetooth bluetooth) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 148, 204, 250),
      appBar: AppBar(
        title: const Text("Cofiguring new user"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bluetooth),
            onPressed: () => showBluetoothScanPage(context),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
                "Because you are a new user, we need to measure the average heart rate and average gsr. Put the fungerwraps over 2 fingers of your choice. After this take the heart rate sensor in between 2 fingers and provide a constant but hard pressure. You can know press the button below to start the measurements."),
            SizedBox(
              width: 200,
              height: 60,
              child: FloatingActionButton(
                  onPressed: () {
                    bluetooth.averageHeartRateMeasurement(
                        Provider.of<SensorData>(context, listen: false));
                    bluetooth.averageGSRMeasurement(
                        Provider.of<SensorData>(context, listen: false));
                  },
                  child: const Text("Start measurement")),
            ),
          ],
        ),
      ),
    );
  }
}
