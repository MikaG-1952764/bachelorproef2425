import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stress_measurement_app/Models/sensor_data.dart';
import 'package:stress_measurement_app/UI/configering_page.dart';
import '../Widgets/heart_rate_gauge.dart';
import '../Widgets/spo2_progress_bar.dart';
import '../Widgets/gsr_line_chart.dart';
import '../Widgets/stress_indicator.dart';
import '../Widgets/bluetooth_device_dialog.dart';
import '../Models/bluetooth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.bluetooth});

  final Bluetooth bluetooth;

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
      MaterialPageRoute(builder: (context) => BluetoothScanPage(bluetoothService: widget.bluetooth)),
    );
  }

  void navigateToConfiguringHeartPage(BuildContext context) async {
    // Navigate to the ConfiguringPage and wait for the result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ConfiguringPage(configuringValue: "Heart Rate")),
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
      MaterialPageRoute(builder: (context) => const ConfiguringPage(configuringValue: "GSR")),
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
    return ChangeNotifierProvider.value(
      value: widget.bluetooth,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 148, 204, 250),
        appBar: AppBar(
          title: const Text("Stress Monitor"),
          centerTitle: true,
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
                      if (bluetooth.isMeasuring) {
                        await bluetooth.stopMeasurement();
                      } else {
                        await bluetooth.startMeasurement(
                            Provider.of<SensorData>(context, listen: false));
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
                    Center(
                        child: SizedBox(
                            width: 300,
                            height: 80,
                            child: StressIndicator(sensorData.gsr))),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black, width: 6),
                          color: Colors.white,
                        ),
                        width: 300,
                        height: 450,
                        child:  Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 10,),
                                const Text('Heart Rate', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.settings),
                                  onPressed: () => navigateToConfiguringHeartPage(context),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                            Expanded(child:  minHeartValue != -1.0 && maxHeartValue != -1.0
                              ? HeartRateGauge(
                                  heartRate: sensorData.heartRate,
                                  minValue: minHeartValue,
                                  maxValue: maxHeartValue,
                                )
                              : HeartRateGauge(heartRate: sensorData.heartRate),)
                          ],
                        ),
                    ),),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 6),
                        color: Colors.white,
                      ),
                      width: 300,
                      height: 300,
                      child: Spo2ProgressBar(sensorData.spo2),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 6),
                        color: Colors.white,
                      ),
                      width: 300,
                      height: 420,
                      child: Column(
                        children: [
                          Row(children: [
                            const SizedBox(width: 10,),
                            const Text('GSR', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                            const Spacer(),
                            IconButton(onPressed: () => navigateToConfiguringGSRPage(context),
                            icon: const Icon(Icons.settings)),
                            const SizedBox(width: 4,),
                          ],),
                          Expanded(child:  minGSRValue != -1.0 && maxGSRValue != -1.0
                              ? GsrLineChart(
                                  gsr: sensorData.gsr,
                                  minValue: minGSRValue,
                                  maxValue: maxGSRValue,
                                )
                              : GsrLineChart(gsr: sensorData.gsr),),
                        ],
                      ),
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
