import 'package:flutter/material.dart';

class ConfiguringPage extends StatelessWidget {
  const ConfiguringPage({super.key, required this.configuringValue});

  final String configuringValue;

  @override
  Widget build(BuildContext context) {
    final minController = TextEditingController();
    final maxController = TextEditingController();
    final amountOfReadsController = TextEditingController();

    if (configuringValue == "Heart Rate") {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Configure Range"),
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                "Configuring $configuringValue",
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              const Text("Min value"),
              const SizedBox(height: 10),
              Container(
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: minController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 20),
              const Text("Max value"),
              const SizedBox(height: 10),
              Container(
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: maxController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 100,
                child: FloatingActionButton(
                  onPressed: () {
                    // Get the values from the controllers
                    final min = double.tryParse(minController.text) ?? 0.0;
                    final max = double.tryParse(maxController.text) ?? 0.0;

                    // Return the values back to the previous screen
                    Navigator.pop(context, {'min': min, 'max': max});
                  },
                  child: const Text("Apply"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 100,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Configure Range"),
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                "Configuring $configuringValue",
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              const Text("Min value"),
              const SizedBox(height: 10),
              Container(
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: minController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 20),
              const Text("Max value"),
              const SizedBox(height: 10),
              Container(
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: maxController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("Amount of reads"),
              Container(
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: amountOfReadsController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 100,
                child: FloatingActionButton(
                  onPressed: () {
                    // Get the values from the controllers
                    final min = double.tryParse(minController.text) ?? 0.0;
                    final max = double.tryParse(maxController.text) ?? 0.0;

                    // Return the values back to the previous screen
                    Navigator.pop(context, {'min': min, 'max': max});
                  },
                  child: const Text("Apply"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 100,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      );
    }
  }
}
