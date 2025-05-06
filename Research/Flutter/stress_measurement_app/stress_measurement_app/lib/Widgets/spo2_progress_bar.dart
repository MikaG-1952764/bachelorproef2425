import 'package:flutter/material.dart';
import 'package:stress_measurement_app/Models/bluetooth.dart';
import 'package:stress_measurement_app/UI/data_history_page.dart';

class Spo2ProgressBar extends StatelessWidget {
  final int spo2;
  const Spo2ProgressBar(this.spo2, {super.key, required this.bluetooth});
  final Bluetooth bluetooth;

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
        Row(
          children: [
            const Text("SpO2 Level",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              width: 4,
            ),
            SizedBox(
              width: 38,
              child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text("SpO2 Level"),
                        content: SizedBox(
                          height: 360,
                          child: Column(
                            children: [
                              const Text(
                                  "Your SpO2 (blood-oxygen level) is measured by the same sensor as your heart rate sensor.\n\nThe SpO2 levels are as follows:\n\n"),
                              Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  const SizedBox(
                                    width: 210,
                                    child: Text(
                                        "A SpO2 level below 90% is considered low and may indicate a health issue."),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  const SizedBox(
                                    width: 210,
                                    child: Text(
                                        "A SpO2 level between 90% and 95% is on the borderline of normal and low."),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  const SizedBox(
                                    width: 210,
                                    child: Text(
                                        "A SpO2 level above 95% is considered normal and healthy."),
                                  )
                                ],
                              ),
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
                  icon: const Icon(Icons.info_outline)),
            ),
          ],
        ),
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
                        builder: (context) => DataHistoryPage(
                              pageName: "Spo2",
                              bluetooth: bluetooth,
                            )));
              }),
        ),
        const Spacer(),
      ],
    );
  }
}
