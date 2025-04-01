import 'package:flutter/material.dart';
import 'package:stress_measurement_app/UI/data_history_page.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GsrLineChart extends StatelessWidget {
  final int gsr;
  final double minValue;
  final double maxValue;
  final Color axisColor;

  const GsrLineChart({
    super.key,
    required this.gsr,
    this.minValue = 100,
    this.maxValue = 1000,
    this.axisColor = Colors.blue, // Default axis color
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
                thickness: 10,
                color: axisColor, // Configurable axis color
              ),
              pointers: [
                MarkerPointer(
                  value: gsr.toDouble(),
                  color: Colors.black,
                  markerHeight: 20,
                ),
              ],
              annotations: [
                GaugeAnnotation(
                  widget: Text(
                    "$gsr GSR",
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
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          height: 40,
          width: 160,
          child: FloatingActionButton(
              child: const Text("GSR data history"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DataHistoryPage(
                              pageName: "GSR",
                            )));
              }),
        ),
        const Spacer(),
      ],
    );
  }
}
