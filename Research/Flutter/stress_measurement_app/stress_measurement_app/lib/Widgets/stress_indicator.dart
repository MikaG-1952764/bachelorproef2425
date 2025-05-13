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

  Future<int?> restingRespiratory() async {
    final readings = await database.getCurrentUserRestingRespirationRate();
    return readings;
  }

  Future<int?> respiratoryRate() async {
    final readings = await database.getLatestRespiratoryRateReadings(1);
    return readings.isNotEmpty ? readings.first['respiratoryRate'] : 0;
  }

  Future<String> get stressLevel async {
    final latestGsrValue = await latestGSR();
    final averageGsrValue = await averageGsr();
    final latestRespiratoryRate = await respiratoryRate();
    final restingRepsiratoryRate = await restingRespiratory();

    print(restingRepsiratoryRate);
    print(latestRespiratoryRate);

    if (latestGsrValue >= (1.10 * averageGsrValue!) ||
        latestRespiratoryRate! >= (restingRepsiratoryRate! * 1.30)) {
      return "Stressed";
    } else if (latestGsrValue >= (1.05 * averageGsrValue!) ||
        latestRespiratoryRate! >= (restingRepsiratoryRate! * 1.20)) {
      return "Moderately Stressed";
    }
    return "No stress detected";
  }

  Future<Color> get stressColor async {
    final latestGsrValue = await latestGSR();
    final averageGsrValue = await averageGsr();
    final latestRespiratoryRate = await respiratoryRate();
    final restingRepsiratoryRate = await restingRespiratory();
    print('averageGsr: ${await database.getCurrentUserAverageGSR()}');
    print(
        'averageHeartRate: ${await database.getCurrentUserAverageHeartRate()}');
    if (latestGsrValue >= (1.10 * averageGsrValue!) ||
        latestRespiratoryRate! >= (restingRepsiratoryRate! * 1.30)) {
      return Colors.red;
    } else if (latestGsrValue >= (1.05 * averageGsrValue!) ||
        latestRespiratoryRate! >= (restingRepsiratoryRate! * 1.20)) {
      return Colors.orange;
    }
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
                child: Row(
              children: [
                Text(level,
                    style: const TextStyle(color: Colors.white, fontSize: 22)),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text("Stress level"),
                          content: SizedBox(
                            height: 420,
                            child: Column(
                              children: [
                                const Text(
                                    "An estimate of how stressed your body is, based on skin response (GSR) and respiration rate. \n IMPORTANT: The stress indicator is only accurate when 'All' is selected when measuring."),
                                const SizedBox(height: 10),
                                const Text(
                                    "Note: This is an approximation — stress is complex and can vary from person to person. The following levels are integrated: \n"),
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
                                          "Your body is stressed. Try to relax and take a break. Your body is stressed if the GSR level is above 10% of your average GSR."),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
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
                                          "Your body is not stressed. You are in a good state of mind. This is a good time to focus on your work or study."),
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
              ],
            )),
          );
        }
      },
    );
  }
}
