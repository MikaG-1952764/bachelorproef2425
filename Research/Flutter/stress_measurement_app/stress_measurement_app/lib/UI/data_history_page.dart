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
                      return LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            verticalInterval: 1,
                            horizontalInterval: 10,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.grey.withOpacity(0.3),
                              strokeWidth: 1,
                            ),
                            getDrawingVerticalLine: (value) => FlLine(
                              color: Colors.grey.withOpacity(0.3),
                              strokeWidth: 1,
                            ),
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(value.toInt().toString(),
                                      style: const TextStyle(fontSize: 10));
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  int index = value.toInt();
                                  if (index >= 0 && index < data.length) {
                                    final date =
                                        _formatShortDate(data[index]['date']);
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(date,
                                          style: const TextStyle(fontSize: 10)),
                                    );
                                  } else {
                                    return const Text('');
                                  }
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: const Border(
                              left: BorderSide(color: Colors.black),
                              bottom: BorderSide(color: Colors.black),
                            ),
                          ),
                          minX: 0,
                          maxX: (data.length - 1).toDouble(),
                          minY: _getMinY(widget.pageName),
                          maxY: _getMaxY(widget.pageName),
                          lineBarsData: [
                            LineChartBarData(
                              isCurved: true,
                              barWidth: 3,
                              dotData: FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.withOpacity(0.3),
                                    Colors.blue.withOpacity(0.0)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              color: Colors.blue,
                              spots: List.generate(data.length, (i) {
                                final value = data[i].values.last.toDouble();
                                return FlSpot(i.toDouble(), value);
                              }),
                            ),
                          ],
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipItems: (spots) => spots.map((spot) {
                                final index = spot.x.toInt();
                                final value = spot.y;
                                final date = _formatDate(data[index]['date']);
                                return LineTooltipItem(
                                  "$date\n${value.toStringAsFixed(1)}",
                                  const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      );
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
        return "${reading['respiratoryRate']} breaths/min"; // Example unit for spo2
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

  String _formatShortDate(String dateString) {
    try {
      final DateFormat inputFormat = DateFormat('yyyy-MM-dd');
      final DateTime parsed = inputFormat.parse(dateString);
      return DateFormat('dd/MM').format(parsed);
    } catch (_) {
      return '';
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
