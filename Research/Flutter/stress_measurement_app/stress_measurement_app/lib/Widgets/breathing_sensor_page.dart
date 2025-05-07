import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stress_measurement_app/Models/bluetooth.dart';
import 'package:stress_measurement_app/Models/database.dart';
import 'package:stress_measurement_app/UI/data_history_page.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            const Text("Respiration Rate",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            const Spacer(),
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text("Respiration Rate"),
                      content: const SizedBox(
                        height: 280,
                        child: Column(
                          children: [
                            Text(
                                "The number of inhalations and exhalations per minute. It reflects how your body responds to physical and emotional states. A higher rate may indicate stress or activity, while a lower rate is often linked to calm and relaxation."),
                            SizedBox(height: 20),
                            Text(
                                "The normal range for an adult in rest is 10-30 breaths per minute. If you just walked/moved, your respiration rate may be outside of this normal range."),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.info_outline))
          ],
        ),
        const SizedBox(height: 50),
        SizedBox(
          height: 250, // or whatever size you want
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                showTicks: false,
                showLastLabel: true,
                minimum: 10,
                maximum: 30,
                axisLineStyle: const AxisLineStyle(
                  thickness: 10,
                  color: Colors.green, // Configurable axis color
                ),
                pointers: [
                  MarkerPointer(
                    value: repsirationRate.toDouble(),
                    color: Colors.black,
                    markerHeight: 20,
                  ),
                ],
                annotations: [
                  GaugeAnnotation(
                    widget: Text(
                      "$repsirationRate breaths/min",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    angle: 90,
                    positionFactor: 0.0,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        /*Center(
          child: Text(
            "Breathing Rate: \n $repsirationRate breaths/min",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ),*/
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
                              pageName: "RespitoryRate",
                              bluetooth: bluetooth,
                            )));
              }),
        ),
      ],
    );
  }
}
