import 'package:flutter/material.dart';

class DataRowWidget extends StatelessWidget {
  final String number;
  final String date;
  final String measurement;

  const DataRowWidget({
    super.key,
    required this.number,
    required this.date,
    required this.measurement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text(number)),
          ),
        ),
        Container(
          width: 100,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text(date)),
          ),
        ),
        Container(
          width: 200,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text(measurement)),
          ),
        ),
      ],
    );
  }
}
