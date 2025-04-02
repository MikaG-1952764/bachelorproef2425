import 'package:flutter/material.dart';
import 'package:stress_measurement_app/Models/bluetooth.dart';
import 'package:stress_measurement_app/UI/data_history_page.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HeartRateGauge extends StatefulWidget {
  final int heartRate;
  final double minValue;
  final double maxValue;
  final List<Color> rangeColors;
  final Bluetooth bluetooth;

  const HeartRateGauge({
    super.key,
    required this.heartRate,
    this.minValue = 50,
    this.maxValue = 200,
    this.rangeColors = const [
      Color.fromARGB(255, 0, 255, 9),
      Color.fromARGB(255, 0, 158, 6),
      Color.fromARGB(255, 255, 251, 0),
      Colors.orange,
      Colors.red
    ],
    required this.bluetooth,
  });

  @override
  _HeartRateGaugeState createState() => _HeartRateGaugeState();
}

class _HeartRateGaugeState extends State<HeartRateGauge> {
  int? maxHeartRate;

  @override
  void initState() {
    super.initState();
    _fetchMaxHeartRate();
  }

  Future<void> _fetchMaxHeartRate() async {
    int? fetchedMaxHeartRate =
        await widget.bluetooth.getDatabase().getCurrentUserMaxHeartRate();
    if (fetchedMaxHeartRate == null) {
      print("Max heart rate not found in database. Setting default value.");
      fetchedMaxHeartRate = 150; // Default value
    }
    setState(() {
      maxHeartRate = fetchedMaxHeartRate;
    });
  }

  List<double> _calculateStops() {
    if (maxHeartRate == null) return [0.0, 0.25, 0.5, 0.75, 1.0];
    print("Max heart rate: $maxHeartRate");
    List<int> thresholdValues = [
      (maxHeartRate! * 0.57).toInt(),
      (maxHeartRate! * 0.63).toInt(),
      (maxHeartRate! * 0.76).toInt(),
      (maxHeartRate! * 0.95).toInt(),
      (maxHeartRate! * 1.0).toInt(),
    ];

    return thresholdValues.map((t) {
      return ((t - widget.minValue) / (widget.maxValue - widget.minValue))
          .clamp(0.0, 1.0);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        if (maxHeartRate == null)
          const CircularProgressIndicator()
        else
          SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                showTicks: false,
                showLastLabel: true,
                minimum: widget.minValue,
                maximum: widget.maxValue,
                axisLineStyle: AxisLineStyle(
                  thickness: 0.1,
                  thicknessUnit: GaugeSizeUnit.factor,
                  gradient: SweepGradient(
                    colors: widget.rangeColors,
                    stops: _calculateStops(),
                  ),
                ),
                pointers: [
                  MarkerPointer(
                    value: widget.heartRate.toDouble(),
                    color: Colors.black,
                    markerHeight: 20,
                  ),
                ],
                annotations: [
                  GaugeAnnotation(
                    widget: Text(
                      "${widget.heartRate} bpm",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    angle: 90,
                    positionFactor: 0.0,
                  ),
                ],
              ),
            ],
          ),
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          height: 40,
          width: 160,
          child: FloatingActionButton(
            child: const Text("Heart data history"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DataHistoryPage(
                    pageName: "Heart Rate",
                    bluetooth: widget.bluetooth,
                  ),
                ),
              );
            },
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
