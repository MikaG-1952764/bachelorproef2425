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
  bool isGraphView = true;

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

  Future<Map<String, dynamic>> fetchMinMaxDataInRange(
      DateTime startDate, DateTime endDate) async {
    switch (widget.pageName) {
      case "Heart Rate":
        final heartRateData = await widget.bluetooth
            .getDatabase()
            .getHeartRateReadingsInRange(startDate, endDate);
        return _getMinMax(heartRateData, 'heartRate');
      case "GSR":
        final gsrData = await widget.bluetooth
            .getDatabase()
            .getGSRReadingsInRange(startDate, endDate);
        return _getMinMax(gsrData, 'gsr');
      case "Spo2":
        final spo2Data = await widget.bluetooth
            .getDatabase()
            .getSpo2ReadingsInRange(startDate, endDate);
        return _getMinMax(spo2Data, 'spo2');
      case "RespiratoryRate":
        final respiratoryRateData = await widget.bluetooth
            .getDatabase()
            .getRespitoryRateReadingsInRange(startDate, endDate);
        return _getMinMax(respiratoryRateData, 'respiratoryRate');
      default:
        return {}; // Return an empty map if no matching page
    }
  }

  Map<String, dynamic> _getMinMax(List<Map<String, dynamic>> data, String key) {
    if (data.isEmpty) {
      return {'min': null, 'max': null}; // Return null if there's no data
    }

    // Ensure the date is parsed to DateTime
    final values = data.map((entry) {
      final dateString = entry['date'] as String;
      final date =
          DateTime.parse(dateString); // Parse the date string into DateTime
      return entry[key] as num;
    }).toList();

    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);

    return {'min': min, 'max': max};
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    dataFuture = fetchDataInRange(
      DateTime(now.year, now.month, now.day),
      now,
    );
    isFilterActive = true;
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
                      dataFuture = fetchDataInRange(weekAgo, now);
                    });
                  },
                  child: const Text("Last 7 Days"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final now = DateTime.now();
                    final monthAgo = now.subtract(const Duration(days: 30));
                    setState(() {
                      isFilterActive = true;
                      dataFuture = fetchDataInRange(monthAgo, now);
                    });
                  },
                  child: const Text("Last 30 Days"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (isGraphView)
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
                ),
              )
            else ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text("Date"),
                    ),
                  ),
                  Container(
                    width: 80,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text("Min"),
                    ),
                  ),
                  Container(
                    width: 80,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text("Max"),
                    ),
                  ),
                ],
              ),
              Expanded(
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
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final entry = data[index];
                        return DataRowWidget(
                          number: (index + 1).toString(),
                          date: entry['date'],
                          measurement: entry.values.last,
                        );
                      },
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

  double _getMinY(String pageName) {
    switch (pageName) {
      case "Heart Rate":
        return 0;
      case "GSR":
        return 0;
      case "Spo2":
        return 90;
      case "RespiratoryRate":
        return 0;
      default:
        return 0;
    }
  }

  double _getMaxY(String pageName) {
    switch (pageName) {
      case "Heart Rate":
        return 120;
      case "GSR":
        return 50;
      case "Spo2":
        return 100;
      case "RespiratoryRate":
        return 40;
      default:
        return 100;
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
