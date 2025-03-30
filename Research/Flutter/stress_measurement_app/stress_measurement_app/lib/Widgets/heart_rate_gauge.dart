import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HeartRateGauge extends StatelessWidget {
  final double heartRate;
  final double minValue;
  final double maxValue;
  final List<int> thresholdValues;
  final List<Color> rangeColors;

  const HeartRateGauge({
    super.key,
    required this.heartRate,
    this.minValue = 50,
    this.maxValue = 150,
    this.thresholdValues = const [120, 180, 250],
    this.rangeColors = const [
      Colors.green,
      Colors.orange,
      Colors.red
    ], // Default gradient colors
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
                  value: heartRate,
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
              child: const Text("Heart data history"), onPressed: () {}),
        ),
        const Spacer(),
      ],
    );
  }

  // Helper function to generate stops for the gradient dynamically
  List<double> _calculateStops() {
    return thresholdValues.map((t) {
      return ((t - minValue) / (maxValue - minValue)).clamp(0.0, 1.0);
    }).toList();
  }
}
