import 'package:flutter/material.dart';
import 'package:stress_measurement_app/UI/data_history_page.dart';

class Spo2ProgressBar extends StatelessWidget {
  final int spo2;
  const Spo2ProgressBar(this.spo2, {super.key});

  Color getSpo2Color(int spo2) {
    if (spo2 < 90) {
      return Colors.red; // Low SpO2 level
    } else if (spo2 >= 90 && spo2 <= 95) {
      return Colors.orange; // Normal SpO2 level
    } else {
      return Colors.green; // Invalid SpO2 level
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text("SpO2 Level",
            style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 65),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Stack(
            children: [
              Container(
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300], // Background color
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) => Container(
                  height: 20,
                  width: constraints.maxWidth * (spo2 / 100),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: getSpo2Color(spo2),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "${spo2.toStringAsFixed(1)}%",
          style: const TextStyle(color: Colors.black, fontSize: 20),
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
              child: const Text("SPO2 data history"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DataHistoryPage(
                              pageName: "Spo2",
                            )));
              }),
        ),
        const Spacer(),
      ],
    );
  }
}
