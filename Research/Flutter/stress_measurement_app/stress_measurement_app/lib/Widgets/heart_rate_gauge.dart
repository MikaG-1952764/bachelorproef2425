import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HeartRateGauge extends StatelessWidget {
  final double heartRate;
  final double minValue;
  final double maxValue;
  final List<Color> rangeColors;

  const HeartRateGauge({
    super.key,
    required this.heartRate,
    this.minValue = 50,
    this.maxValue = 150,
    this.rangeColors = const [Colors.green, Colors.green, Colors.orange, Colors.red], // Default gradient colors
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Spacer(),
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
                  stops: _generateStops(rangeColors.length), // Dynamically calculated stops
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
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  angle: 90,
                  positionFactor: 0.0,
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }

  // Helper function to generate stops for the gradient dynamically
  List<double> _generateStops(int length) {
    return List.generate(length, (index) => index / (length - 1));
  }
}
