import 'package:flutter/material.dart';

class ChoosingRunModePage extends StatelessWidget {
  const ChoosingRunModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Run Mode'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 120,
            ),
            const Text(
              'Choose a run mode:',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 80,
            ),
            SizedBox(
              height: 50,
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the first run mode page
                },
                child: const Text(
                  'Measure in time',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 50,
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the second run mode page
                },
                child: const Text(
                  'Measure number of samples',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
