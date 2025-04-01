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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
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
            Row(
              children: [
                Container(
                  width: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: Text("1")),
                  ),
                ),
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: Text("20/03/2023")),
                  ),
                ),
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: Text("120 beats/min")),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
