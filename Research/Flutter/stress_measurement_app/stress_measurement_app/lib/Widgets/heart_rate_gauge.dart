import 'package:flutter/material.dart';
import 'package:stress_measurement_app/Models/bluetooth.dart';
import 'package:stress_measurement_app/UI/data_history_page.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HeartRateGauge extends StatelessWidget {
  final int heartRate;
  final double minValue;
  final double maxValue;
  final List<Color> rangeColors;
  final Bluetooth bluetooth;

  const HeartRateGauge({
    super.key,
    required this.heartRate,
    this.minValue = 50,
    this.maxValue = 150,
    this.rangeColors = const [
      Color.fromARGB(255, 0, 255, 9),
      Color.fromARGB(255, 0, 158, 6),
      Color.fromARGB(255, 255, 251, 0),
      Colors.orange,
      Colors.red
    ],
    required this.bluetooth, // Default gradient colors
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              showTicks: false,
              showLastLabel: true,
              minimum: minValue,
              maximum: maxValue,
              axisLineStyle: AxisLineStyle(
                thickness: 0.1,
                thicknessUnit: GaugeSizeUnit.factor,
                gradient: SweepGradient(
                  colors: rangeColors, // Configurable colors
                  stops: _calculateStops(),
                ),
              ),
              pointers: [
                MarkerPointer(
                  value: heartRate.toDouble(),
                  color: Colors.black,
                  markerHeight: 20,
                ),
              ],
              annotations: [
                GaugeAnnotation(
                  widget: Text(
                    "$heartRate bpm",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  angle: 90,
                  positionFactor: 0.0,
                ),
              ],
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          height: 40,
          width: 160,
          child: FloatingActionButton(
              child: const Text("Heart data history"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DataHistoryPage(
                              pageName: "Heart Rate",
                              bluetooth: bluetooth,
                            )));
              }),
        ),
        const Spacer(),
      ],
    );
  }

  // Helper function to generate stops for the gradient dynamically
  List<double> _calculateStops() {
    int maxHeartRate = 200;
    List<int> thresholdValues = [
      (maxHeartRate * 0.57).toInt(),
      (maxHeartRate * 0.63).toInt(),
      (maxHeartRate * 0.76).toInt(),
      (maxHeartRate * 0.95).toInt(),
      (maxHeartRate * 1.0).toInt(),
    ];
    return thresholdValues.map((t) {
      return ((t - minValue) / (maxValue - minValue)).clamp(0.0, 1.0);
    }).toList();
  }
}
