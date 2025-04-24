import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stress_measurement_app/Models/bluetooth.dart';
import 'package:stress_measurement_app/UI/data_history_page.dart';

class BreathingSensorPage extends StatelessWidget {
  const BreathingSensorPage({
    super.key,
    required this.bluetooth,
    required this.repsirationRate,
  });

  final Bluetooth bluetooth;
  final int repsirationRate; // Example value, replace with actual data

  @override
  Widget build(BuildContext context) {
    List<FlSpot> generateBreathingGraph(int breathsPerMinute) {
      List<FlSpot> points = [];
      double secondsPerBreath = 60 / breathsPerMinute;
      double totalTime = 20.0;
      double step = 0.1; // smaller = smoother curve

      for (double t = 0; t <= totalTime; t += step) {
        double phase = 2 * pi * (t % secondsPerBreath) / secondsPerBreath;
        double y = sin(phase); // breathing up/down
        points.add(FlSpot(t, y));
      }
      return points;
    }

    return Column(
      children: [
        const SizedBox(height: 10),
        const Text("Respiration Rate",
            style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 50),
        SizedBox(
          height: 200, // or whatever size you want
          child: LineChart(
            LineChartData(
              minY: -1.2,
              maxY: 1.2,
              titlesData: const FlTitlesData(show: false),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              lineTouchData: const LineTouchData(enabled: false),
              lineBarsData: [
                LineChartBarData(
                  spots: generateBreathingGraph(repsirationRate),
                  isCurved: true,
                  color: Colors.blue,
                  belowBarData: BarAreaData(show: false),
                  dotData: const FlDotData(show: false),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            "Breathing Rate: \n $repsirationRate breaths/min",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 40),
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          height: 40,
          width: 160,
          child: FloatingActionButton(
              child: const Text("Respiration history"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DataHistoryPage(
                              pageName: "Spo2",
                              bluetooth: bluetooth,
                            )));
              }),
        ),
      ],
    );
  }
}
