import 'package:flutter/material.dart';

class StressIndicator extends StatelessWidget {
  final int gsr;
  const StressIndicator(this.gsr, {super.key});

  String get stressLevel {
    if (gsr < 0.3) return "Low Stress";
    if (gsr < 0.7) return "Medium Stress";
    return "High Stress";
  }

  Color get stressColor {
    if (gsr < 0.3) return Colors.green;
    if (gsr < 0.7) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: stressColor, borderRadius: BorderRadius.circular(10)),
      child: Center(
          child: Text(stressLevel,
              style: const TextStyle(color: Colors.white, fontSize: 26))),
    );
  }
}
