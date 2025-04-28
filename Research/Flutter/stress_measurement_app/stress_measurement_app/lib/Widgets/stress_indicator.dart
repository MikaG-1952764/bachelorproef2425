import 'package:flutter/material.dart';
import 'package:stress_measurement_app/Models/database.dart';

class StressIndicator extends StatelessWidget {
  final int gsr;
  final AppDatabase database;
  const StressIndicator(this.gsr, this.database, {super.key});

  Future<int> latestGSR() async {
    final readings = await database.getLatestGSRReadings(1);
    return readings.isNotEmpty ? readings.first['gsr'] : 0;
  }

  Future<int?> averageGsr() async {
    final readings = await database.getCurrentUserAverageGSR();
    return readings;
  }

  Future<String> get stressLevel async {
    final latestGsrValue = await latestGSR();
    final averageGsrValue = await averageGsr();
    if (latestGsrValue > (0.023 * averageGsrValue!)) return "Stressed";
    return "No stress detected";
  }

  Future<Color> get stressColor async {
    final latestGsrValue = await latestGSR();
    final averageGsrValue = await averageGsr();
    if (latestGsrValue > (0.023 * averageGsrValue!)) return Colors.red;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([stressColor, stressLevel]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Error loading stress data');
        } else {
          final color = snapshot.data![0] as Color;
          final level = snapshot.data![1] as String;
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(10)),
            child: Center(
                child: Text(level,
                    style: const TextStyle(color: Colors.white, fontSize: 26))),
          );
        }
      },
    );
  }
}
