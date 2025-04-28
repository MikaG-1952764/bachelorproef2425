import 'package:flutter/material.dart';
import 'package:stress_measurement_app/Models/database.dart';
import 'package:stress_measurement_app/Widgets/breathing_sensor_page.dart';
import '../Models/sensor_data.dart';
import '../Models/bluetooth.dart';
import 'heart_rate_gauge.dart';
import 'spo2_progress_bar.dart';
import 'gsr_line_chart.dart';

class SensorCardsPager extends StatefulWidget {
  final double minHeartValue;
  final double maxHeartValue;
  final double minGSRValue;
  final double maxGSRValue;
  final SensorData sensorData;
  final Bluetooth bluetooth;
  final VoidCallback onHeartConfig;
  final VoidCallback onGSRConfig;

  const SensorCardsPager({
    super.key,
    required this.minHeartValue,
    required this.maxHeartValue,
    required this.minGSRValue,
    required this.maxGSRValue,
    required this.sensorData,
    required this.bluetooth,
    required this.onHeartConfig,
    required this.onGSRConfig,
  });

  @override
  State<SensorCardsPager> createState() => _SensorCardsPagerState();
}

class _SensorCardsPagerState extends State<SensorCardsPager> {
  final PageController _controller = PageController(viewportFraction: 0.75);
  double _currentPage = 0;

  late AppDatabase database;

  @override
  void initState() {
    super.initState();
    database = widget.bluetooth.getDatabase();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page!;
      });
    });
  }

  Future<int> latestHeartRate() async {
    final readings = await database.getLatestHeartRateReadings(1);
    return readings.isNotEmpty ? readings.first['heartRate'] : 0;
  }

  Future<int> latestSpo2() async {
    final readings = await database.getLatestSpo2Readings(1);
    return readings.isNotEmpty ? readings.first['spo2'] : 0;
  }

  Future<int> latestGSR() async {
    final readings = await database.getLatestGSRReadings(1);
    return readings.isNotEmpty ? readings.first['gsr'] : 0;
  }

  Future<int> latestRespiratoryRate() async {
    final readings = await database.getLatestRespitoryRateReadings(1);
    return readings.isNotEmpty ? readings.first['respiratoryRate'] : 0;
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      FutureBuilder<int>(
        future: latestHeartRate(),
        builder: (context, snapshot) {
          final heartRate = snapshot.data ?? widget.sensorData.heartRate;
          return _buildCard(
            index: 0,
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 10),
                    const Text('Heart Rate',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    SizedBox(
                      width: 38,
                      child: IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: widget.onHeartConfig,
                      ),
                    ),
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 38,
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.info_outline)),
                    ),
                    //const SizedBox(width: 22),
                  ],
                ),
                Expanded(
                  child: widget.minHeartValue != -1.0 &&
                          widget.maxHeartValue != -1.0
                      ? HeartRateGauge(
                          heartRate: heartRate,
                          minValue: widget.minHeartValue,
                          maxValue: widget.maxHeartValue,
                          bluetooth: widget.bluetooth,
                        )
                      : HeartRateGauge(
                          heartRate: heartRate,
                          bluetooth: widget.bluetooth,
                        ),
                ),
              ],
            ),
          );
        },
      ),
      FutureBuilder<int>(
        future: latestSpo2(),
        builder: (context, snapshot) {
          final spo2 = snapshot.data ?? widget.sensorData.spo2;
          return _buildCard(
            index: 1,
            child: Spo2ProgressBar(
              spo2,
              bluetooth: widget.bluetooth,
            ),
          );
        },
      ),
      FutureBuilder<int>(
        future: latestGSR(),
        builder: (context, snapshot) {
          final gsr = snapshot.data ?? widget.sensorData.gsr;
          return _buildCard(
            index: 2,
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 10),
                    const Text('GSR',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: widget.onGSRConfig,
                    ),
                  ],
                ),
                Expanded(
                  child:
                      widget.minGSRValue != -1.0 && widget.maxGSRValue != -1.0
                          ? GsrLineChart(
                              gsr: gsr,
                              minValue: widget.minGSRValue,
                              maxValue: widget.maxGSRValue,
                              bluetooth: widget.bluetooth,
                            )
                          : GsrLineChart(
                              gsr: gsr,
                              bluetooth: widget.bluetooth,
                            ),
                ),
              ],
            ),
          );
        },
      ),
      FutureBuilder<int>(
        future: latestRespiratoryRate(),
        builder: (context, snapshot) {
          final respiratoryRate = snapshot.data ?? 0;
          return _buildCard(
            index: 3,
            child: BreathingSensorPage(
              bluetooth: widget.bluetooth,
              repsirationRate: respiratoryRate,
            ),
          );
        },
      ),
    ];

    return SizedBox(
      height: 490,
      child: PageView.builder(
        controller: _controller,
        itemCount: pages.length,
        itemBuilder: (context, index) {
          final scale = (1 - (_currentPage - index).abs()).clamp(0.9, 1.0);
          final opacity = (1 - (_currentPage - index).abs()).clamp(0.5, 1.0);

          return Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: pages[index],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard({required int index, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.black,
              width: 3,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
