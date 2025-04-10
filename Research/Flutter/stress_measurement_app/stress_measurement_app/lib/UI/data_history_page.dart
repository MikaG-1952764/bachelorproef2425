import 'package:flutter/material.dart';
import 'package:stress_measurement_app/Models/bluetooth.dart';
import 'package:stress_measurement_app/Widgets/data_row.dart';
import 'package:intl/intl.dart';

class DataHistoryPage extends StatelessWidget {
  const DataHistoryPage(
      {super.key, required this.pageName, required this.bluetooth});
  final String pageName;
  final Bluetooth bluetooth;
  @override
  Widget build(BuildContext context) {
    final TextEditingController startDateController = TextEditingController();
    final TextEditingController endDateController = TextEditingController();
    Future<List<Map<String, dynamic>>> fetchData() {
      switch (pageName) {
        case "Heart Rate":
          return bluetooth.getDatabase().getLatestHeartRateReadings(10);
        case "GSR":
          return bluetooth.getDatabase().getLatestGSRReadings(10);
        case "Spo2":
          return bluetooth.getDatabase().getLatestSpo2Readings(10);
        default:
          return Future.value([]);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("$pageName data history"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_sharp),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Filter"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Select a date range"),
                          const SizedBox(height: 10),
                          TextField(
                            controller: startDateController,
                            decoration: const InputDecoration(
                              labelText: "Start Date",
                              border: OutlineInputBorder(),
                            ),
                            readOnly: true,
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2101),
                              ).then((pickedDate) {
                                if (pickedDate != null) {
                                  final formattedDate = DateFormat('dd/MM/yyyy')
                                      .format(pickedDate);
                                  startDateController.text = formattedDate;
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: endDateController,
                            decoration: const InputDecoration(
                              labelText: "End Date",
                              border: OutlineInputBorder(),
                            ),
                            readOnly: true,
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2101),
                              ).then((pickedDate) {
                                if (pickedDate != null) {
                                  final formattedDate = DateFormat('dd/MM/yyyy')
                                      .format(pickedDate);
                                  endDateController.text = formattedDate;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          child: const Text("Apply"),
                          onPressed: () {
                            // Apply filter logic here
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                        child: Text("Nr.",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                ),
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                        child: Text("Date",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                ),
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                        child: Text("Measurement",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                ),
              ],
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchData(), // Fetch latest 10 readings
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No data available.");
                }

                final readings = snapshot.data!;
                return Column(
                  children: readings.asMap().entries.map((entry) {
                    final index = entry.key + 1;
                    final reading = entry.value;
                    return DataRowWidget(
                      number: index.toString(),
                      date: reading['date'],
                      measurement: _formatMeasurement(reading),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatMeasurement(Map<String, dynamic> reading) {
    switch (pageName) {
      case "Heart Rate":
        return "${reading['heartRate']} bpm";
      case "GSR":
        return "${reading['gsr']} µS"; // Example unit for GSR
      case "Spo2":
        return "${reading['spo2']} ms"; // Example unit for spo2
      default:
        return "Unknown";
    }
  }
}
