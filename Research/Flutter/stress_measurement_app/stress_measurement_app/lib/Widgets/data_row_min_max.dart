import 'package:flutter/material.dart';

class DataRowMinMaxWidget extends StatelessWidget {
  final String date;
  final String min;
  final String max;

  const DataRowMinMaxWidget({
    super.key,
    required this.date,
    required this.min,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
          width: 120,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text(min)),
          ),
        ),
        Container(
          width: 120,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text(max)),
          ),
        ),
      ],
    );
  }
}
