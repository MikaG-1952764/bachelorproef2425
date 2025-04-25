import 'package:flutter/material.dart';
import 'package:stress_measurement_app/Models/bluetooth.dart';
import 'package:stress_measurement_app/Widgets/data_row.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class DataHistoryPage extends StatefulWidget {
  const DataHistoryPage(
      {super.key, required this.pageName, required this.bluetooth});
  final String pageName;
  final Bluetooth bluetooth;

  @override
  State<DataHistoryPage> createState() => _DataHistoryPageState();
}

class _DataHistoryPageState extends State<DataHistoryPage> {
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  late Future<List<Map<String, dynamic>>> dataFuture;
  bool isFilterActive = false;

  Future<List<Map<String, dynamic>>> fetchData() {
    switch (widget.pageName) {
      case "Heart Rate":
        return widget.bluetooth.getDatabase().getLatestHeartRateReadings(10);
      case "GSR":
        return widget.bluetooth.getDatabase().getLatestGSRReadings(10);
      case "Spo2":
        return widget.bluetooth.getDatabase().getLatestSpo2Readings(10);
      case "RespitoryRate":
        return widget.bluetooth
            .getDatabase()
            .getLatestRespitoryRateReadings(10);
      default:
        return Future.value([]);
    }
  }

  @override
  void initState() {
    super.initState();
    dataFuture = fetchData();
  }

  Widget build(BuildContext context) {
    Future<List<Map<String, dynamic>>> fetchDataInRange(
        DateTime startDate, DateTime endDate) {
      switch (widget.pageName) {
        case "Heart Rate":
          return widget.bluetooth
              .getDatabase()
              .getHeartRateReadingsInRange(startDate, endDate);
        case "GSR":
          return widget.bluetooth
              .getDatabase()
              .getGSRReadingsInRange(startDate, endDate);
        case "Spo2":
          return widget.bluetooth
              .getDatabase()
              .getSpo2ReadingsInRange(startDate, endDate);
        case "RespitoryRate":
          return widget.bluetooth
              .getDatabase()
              .getRespitoryRateReadingsInRange(startDate, endDate);
        default:
          return Future.value([]);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.pageName} data history"),
        actions: [
          if (isFilterActive)
            IconButton(
                onPressed: () {
                  setState(() {
                    isFilterActive = false;
                    startDateController.clear();
                    endDateController.clear();
                    dataFuture = fetchData();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Filter removed"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.filter_alt_off_sharp)),
          IconButton(
            icon: const Icon(Icons.filter_alt_sharp),
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
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
                                lastDate: DateTime.now(),
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
                                lastDate: DateTime.now(),
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
                          child: const Text("Cancel"),
                          onPressed: () {
                            startDateController.clear();
                            endDateController.clear();
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          child: const Text("Apply"),
                          onPressed: () {
                            final DateFormat formatter =
                                DateFormat('dd/MM/yyyy');
                            final DateTime? startDate =
                                formatter.parse(startDateController.text);
                            final DateTime? endDate =
                                formatter.parse(endDateController.text);
                            setState(() {
                              isFilterActive = true;
                              dataFuture =
                                  fetchDataInRange(startDate!, endDate!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Filtering between ${startDateController.text} and ${endDateController.text}"),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              startDateController.clear();
                              endDateController.clear();
                            }); // Refresh the UI
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
            SizedBox(
                height: 200,
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: dataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("No data available."));
                      }

                      final data = snapshot.data!;
                      return LineChart(LineChartData(
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: false,
                            spots: [
                              if (data.isNotEmpty)
                                FlSpot(
                                    0,
                                    data[0]
                                        .values
                                        .last
                                        .toDouble()), // Using the first value of the first data object
                              if (data.length > 1)
                                FlSpot(
                                    1,
                                    data[1]
                                        .values
                                        .last
                                        .toDouble()), // First value of the second object
                              if (data.length > 2)
                                FlSpot(
                                    2,
                                    data[2]
                                        .values
                                        .last
                                        .toDouble()), // First value of the third object
                              if (data.length > 3)
                                FlSpot(3, data[3].values.last.toDouble()),
                              if (data.length > 4)
                                FlSpot(4, data[4].values.last.toDouble()),
                              if (data.length > 5)
                                FlSpot(5, data[5].values.last.toDouble()),
                              if (data.length > 6)
                                FlSpot(6, data[6].values.last.toDouble()),
                              if (data.length > 7)
                                FlSpot(7, data[7].values.last.toDouble()),
                              if (data.length > 8)
                                FlSpot(8, data[8].values.last.toDouble()),
                              if (data.length > 9)
                                FlSpot(9, data[9].values.last.toDouble()),
                              if (data.length > 10)
                                FlSpot(10, data[10].values.last.toDouble()),
                            ],
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(show: true),
                          )
                        ],
                        minX: -0.5, // Add padding by adjusting the minX
                        maxX: data.length.toDouble() + 0.5,
                        minY: _getMinY(widget.pageName),
                        maxY: _getMaxY(widget.pageName),
                        // Adjust this based on your data range
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipItems: (List<LineBarSpot> touchedSpots) {
                              return touchedSpots.map((spot) {
                                return LineTooltipItem(
                                  "${spot.y}",
                                  const TextStyle(color: Colors.white),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ));
                    },
                  ),
                )),
            const SizedBox(height: 10),
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
              future: dataFuture, // Fetch latest 10 readings
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
                      date: _formatDate(reading['date']),
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
    switch (widget.pageName) {
      case "Heart Rate":
        return "${reading['heartRate']} bpm";
      case "GSR":
        return "${reading['gsr']} µS"; // Example unit for GSR
      case "Spo2":
        return "${reading['spo2']} ms";
      case "RespitoryRate":
        return "${reading['respitoryRate']} breaths/mine"; // Example unit for spo2
      default:
        return "Unknown";
    }
  }

  String _formatDate(String dateString) {
    try {
      // Parse the American date string to a DateTime object
      final DateFormat americanFormat = DateFormat('yyyy-MM-dd');
      final DateTime parsedDate = americanFormat.parse(dateString);

      // Convert the DateTime object to European format
      final DateFormat europeanFormat = DateFormat('dd/MM/yyyy');
      return europeanFormat.format(parsedDate);
    } catch (e) {
      print("Error parsing date: $e");
      return dateString; // Return the original string if parsing fails
    }
  }

  double? _getMinY(String pageName) {
    switch (pageName) {
      case "Heart Rate":
        return 0;
      case "GSR":
        return null; // Example, adjust based on your GSR data range
      case "Spo2":
        return 0; // Example, adjust based on your SpO2 data range
      default:
        return null; // Default minY
    }
  }

  double? _getMaxY(String pageName) {
    switch (pageName) {
      case "Heart Rate":
        return 340; // Adjust according to your HR data range
      case "GSR":
        return null; // Example, adjust based on your GSR data range
      case "Spo2":
        return 140; // Example, adjust based on your SpO2 data range
      default:
        return null; // Default maxY
    }
  }
}
