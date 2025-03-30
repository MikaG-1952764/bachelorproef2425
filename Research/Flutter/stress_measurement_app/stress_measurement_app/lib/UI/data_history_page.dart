import 'package:flutter/material.dart';

class DataHistoryPage extends StatelessWidget {
  const DataHistoryPage({super.key, required this.pageName});
  final String pageName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$pageName data history"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.0)),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Dummy text"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
