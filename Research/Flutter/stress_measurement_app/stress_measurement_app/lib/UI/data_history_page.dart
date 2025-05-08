import 'package:flutter/material.dart';
import 'package:stress_measurement_app/Models/bluetooth.dart';
import 'package:stress_measurement_app/Widgets/data_row.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stress_measurement_app/Widgets/data_row_min_max.dart';

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
  bool isGraphView = true; // Example value, replace with actual calculation

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

  Future<List<Map<String, dynamic>>> fetchMinMaxDataInRange(
      DateTime startDate, DateTime endDate) async {
    switch (widget.pageName) {
      case "Heart Rate":
        return widget.bluetooth
            .getDatabase()
            .getDailyMinMaxHeartRateInRange(startDate, endDate);
      case "GSR":
        return widget.bluetooth
            .getDatabase()
            .getDailyMinMaxGSRInRange(startDate, endDate);
      case "Spo2":
        return widget.bluetooth
            .getDatabase()
            .getDailyMinMaxSpO2InRange(startDate, endDate);
      case "RespitoryRate":
        return widget.bluetooth
            .getDatabase()
            .getDailyMinMaxRespiratoryRateInRange(startDate, endDate);
      default:
        return Future.value([]);
    }
  }

  Future<int?>? averageGsr;
  String filter = "Today";

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    dataFuture = fetchDataInRange(
      DateTime(now.year, now.month, now.day),
      now,
    );
    isFilterActive = true;
    averageGsr = widget.bluetooth.getDatabase().getCurrentUserAverageGSR();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.pageName} data history"),
        actions: [
          IconButton(
            icon: Icon(isGraphView ? Icons.table_chart : Icons.show_chart),
            onPressed: () {
              setState(() {
                isGraphView = !isGraphView;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final now = DateTime.now();
                    setState(() {
                      isFilterActive = true;
                      filter = "Today";
                      dataFuture = fetchDataInRange(
                        DateTime(now.year, now.month, now.day),
                        now,
                      );
                    });
                  },
                  child: const Text("Today"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final now = DateTime.now();
                    final weekAgo = now.subtract(const Duration(days: 7));
                    setState(() {
                      isFilterActive = true;
                      filter = "Last 7 days";
                      dataFuture = fetchMinMaxDataInRange(weekAgo, now);
                    });
                  },
                  child: const Text("Last 7 days"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final now = DateTime.now();
                    final monthAgo = now.subtract(const Duration(days: 30));
                    setState(() {
                      isFilterActive = true;
                      filter = "Last 30 days";
                      dataFuture = fetchMinMaxDataInRange(monthAgo, now);
                    });
                  },
                  child: const Text("Last 30 days"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (isGraphView && filter == "Today")
              SizedBox(
                height: 300,
                width: 350,
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
                              dotData: const FlDotData(show: true),
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
                                final date = _formatDate(data[index]['day']);
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
                ),
              )
            else if (isGraphView && filter == "Last 7 days") ...[
              Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  SizedBox(
                    height: 300,
                    width: 350,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: dataFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text("Error: ${snapshot.error}"));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text("No data available."));
                          }

                          final data = snapshot.data!;
                          return BarChart(
                            BarChartData(
                              barGroups: data.asMap().entries.map((entry) {
                                final index = entry.key;
                                final item = entry.value;
                                final min = item['min'] as int;
                                final max = item['max'] as int;
                                return BarChartGroupData(
                                  x: index,
                                  barRods: [
                                    BarChartRodData(
                                      fromY: min.toDouble(),
                                      toY: max.toDouble(),
                                      width: 8,
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.zero,
                                    )
                                  ],
                                  showingTooltipIndicators: [0],
                                );
                              }).toList(),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        final index = value.toInt();
                                        if (index < 0 || index >= data.length) {
                                          return const SizedBox();
                                        }
                                        final dateStr = data[index]['day']
                                            .toString()
                                            .split(' ')[0];
                                        return Text(dateStr
                                            .substring(5)); // Shows MM-DD
                                      }),
                                ),
                                topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: (widget.pageName == "GSR")
                                            ? 40
                                            : 36)),
                                rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: const FlGridData(show: true),
                              minY: _getMinY(widget.pageName),
                              maxY: _getMaxY(widget.pageName),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              )
            ] else if (isGraphView && filter == "Last 30 days") ...[
              Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  SizedBox(
                    height: 300,
                    width: 350,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: dataFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text("Error: ${snapshot.error}"));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text("No data available."));
                          }

                          final data = snapshot.data!;
                          print("data size: ${data.length}");
                          return BarChart(
                            BarChartData(
                              barGroups: data.asMap().entries.map((entry) {
                                final index = entry.key;
                                final item = entry.value;
                                final min = item['min'] as int;
                                final max = item['max'] as int;
                                return BarChartGroupData(
                                  x: index,
                                  barRods: [
                                    BarChartRodData(
                                      fromY: min.toDouble(),
                                      toY: max.toDouble(),
                                      width: 8,
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.zero,
                                    )
                                  ],
                                  showingTooltipIndicators: [0],
                                );
                              }).toList(),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        final index = value.toInt();
                                        if (index < 0 || index >= data.length) {
                                          return const SizedBox();
                                        }
                                        final dateStr = data[index]['day']
                                            .toString()
                                            .split(' ')[0];
                                        return Text(dateStr
                                            .substring(5)); // Shows MM-DD
                                      }),
                                ),
                                topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: (widget.pageName == "GSR")
                                            ? 40
                                            : 36)),
                                rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: const FlGridData(show: true),
                              minY: _getMinY(widget.pageName),
                              maxY: _getMaxY(widget.pageName),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              )
            ] else if (filter == "Last 7 days" || filter == "Last 30 days") ...[
              const SizedBox(height: 10),
              Row(
                children: [
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
                    width: 120,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                          child: Text("Min",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ),
                  ),
                  Container(
                    width: 120,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                          child: Text("Max",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
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
                        final reading = entry.value;
                        return DataRowMinMaxWidget(
                          date: _formatDate(reading['day']),
                          min: _formatMinMeasurement(reading),
                          max: _formatMaxMeasurement(reading),
                        );
                      }).toList(),
                    );
                  },
                ),
              )
            ] else ...[
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
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
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
              )
            ],
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

  String _formatMinMeasurement(Map<String, dynamic> reading) {
    switch (widget.pageName) {
      case "Heart Rate":
        return "${reading['min']} bpm";
      case "GSR":
        return "${reading['min']} µS"; // Example unit for GSR
      case "Spo2":
        return "${reading['min']} ms";
      case "RespitoryRate":
        return "${reading['min']} breaths/min"; // Example unit for spo2
      default:
        return "Unknown";
    }
  }

  String _formatMaxMeasurement(Map<String, dynamic> reading) {
    switch (widget.pageName) {
      case "Heart Rate":
        return "${reading['max']} bpm";
      case "GSR":
        return "${reading['max']} µS"; // Example unit for GSR
      case "Spo2":
        return "${reading['max']} ms";
      case "RespitoryRate":
        return "${reading['max']} breaths/min"; // Example unit for spo2
      default:
        return "Unknown";
    }
  }

  double? _getMinY(String pageName) {
    switch (pageName) {
      case "Heart Rate":
        return 0;
      case "GSR":
        return 1000; // Example, adjust based on your GSR data range
      case "Spo2":
        return 0; // Example, adjust based on your SpO2 data range
      default:
        return null; // Default minY
    }
  }

  double? _getMaxY(String pageName) {
    switch (pageName) {
      case "Heart Rate":
        return 250; // Adjust according to your HR data range
      case "GSR":
        return 2500; // Example, adjust based on your GSR data range
      case "Spo2":
        return 140; // Example, adjust based on your SpO2 data range
      default:
        return null; // Default maxY
    }
  }

  String _formatDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  String _formatShortDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    final DateFormat formatter = DateFormat('MM-dd');
    return formatter.format(dateTime);
  }
}
