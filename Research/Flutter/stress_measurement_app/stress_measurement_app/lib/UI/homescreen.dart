import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stress_measurement_app/Models/database.dart';
import 'package:stress_measurement_app/Models/sensor_data.dart';
import 'package:stress_measurement_app/UI/configering_page.dart';
import 'package:stress_measurement_app/UI/user_selection.dart';
import 'package:stress_measurement_app/Widgets/pager_widget.dart';
import 'package:stress_measurement_app/Widgets/sensor_cards_pager.dart';
import '../Widgets/stress_indicator.dart';
import '../Widgets/bluetooth_device_dialog.dart';
import '../Models/bluetooth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {super.key, required this.bluetooth, required this.isNewUser});

  final Bluetooth bluetooth;
  final bool isNewUser;

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double minHeartValue = -1.0;
  double maxHeartValue = -1.0;
  double minGSRValue = -1.0;
  double maxGSRValue = -1.0;

  void showBluetoothScanPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              BluetoothScanPage(bluetoothService: widget.bluetooth)),
    );
  }

  void navigateToConfiguringHeartPage(BuildContext context) async {
    // Navigate to the ConfiguringPage and wait for the result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const ConfiguringPage(configuringValue: "Heart Rate")),
    );

    // If result is not null, update the min and max values
    if (result != null) {
      setState(() {
        minHeartValue = result['min'];
        maxHeartValue = result['max'];
      });
    }
  }

  void navigateToConfiguringGSRPage(BuildContext context) async {
    // Navigate to the ConfiguringPage and wait for the result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const ConfiguringPage(configuringValue: "GSR")),
    );

    // If result is not null, update the min and max values
    if (result != null) {
      setState(() {
        minGSRValue = result['min'];
        maxGSRValue = result['max'];
      });
    }
  }

  Future<void> insertSampleDataWithDate(AppDatabase db) async {
    // Add test users
    await db.insertUserUserTesting(
        'Mika', 191, 62, 1586, 11); // Max heart rate 180

    print('current user: ${await db.getCurrentUser()}');

    // Insert heart rate data for the users with dates
    // Week 1
    await db.insertHeartRateUserTestingPast(72, 1); // Day 1 AM - HR: 72
    await db.insertHeartRateUserTestingPast(85, 1); // Day 1 PM - HR: 145
    await db.insertHeartRateUserTestingPast(75, 2); // Day 2 AM - HR: 75
    await db.insertHeartRateUserTestingPast(90, 2); // Day 2 PM - HR: 165
    await db.insertHeartRateUserTestingPast(68, 3); // Day 3 AM - HR: 68
    await db.insertHeartRateUserTestingPast(80, 3); // Day 3 PM - HR: 155
    await db.insertHeartRateUserTestingPast(82, 4); // Day 4 AM - HR: 82
    await db.insertHeartRateUserTestingPast(100, 4); // Day 4 PM - HR: 170
    await db.insertHeartRateUserTestingPast(75, 5); // Day 5 AM - HR: 75
    await db.insertHeartRateUserTestingPast(90, 5); // Day 5 PM - HR: 160
    await db.insertHeartRateUserTestingPast(70, 6); // Day 6 AM - HR: 70
    await db.insertHeartRateUserTestingPast(120, 6); // Day 6 PM - HR: 190
    await db.insertHeartRateUserTestingPast(60, 7); // Day 7 AM - HR: 60
    await db.insertHeartRateUserTestingPast(85, 7); // Day 7 PM - HR: 150

// Week 2 (same days, larger difference on higher heart rate)
    await db.insertHeartRateUserTestingPast(76, 8); // Day 1 AM - HR: 76
    await db.insertHeartRateUserTestingPast(95, 8); // Day 1 PM - HR: 155
    await db.insertHeartRateUserTestingPast(77, 9); // Day 2 AM - HR: 77
    await db.insertHeartRateUserTestingPast(95, 9); // Day 2 PM - HR: 160
    await db.insertHeartRateUserTestingPast(69, 10); // Day 3 AM - HR: 69
    await db.insertHeartRateUserTestingPast(90, 10); // Day 3 PM - HR: 160
    await db.insertHeartRateUserTestingPast(80, 11); // Day 4 AM - HR: 80
    await db.insertHeartRateUserTestingPast(110, 11); // Day 4 PM - HR: 180
    await db.insertHeartRateUserTestingPast(78, 12); // Day 5 AM - HR: 78
    await db.insertHeartRateUserTestingPast(95, 12); // Day 5 PM - HR: 170
    await db.insertHeartRateUserTestingPast(65, 13); // Day 6 AM - HR: 65
    await db.insertHeartRateUserTestingPast(125, 13); // Day 6 PM - HR: 200
    await db.insertHeartRateUserTestingPast(58, 14); // Day 7 AM - HR: 58
    await db.insertHeartRateUserTestingPast(85, 14); // Day 7 PM - HR: 150

// Week 3 (same days, larger difference on higher heart rate)
    await db.insertHeartRateUserTestingPast(80, 15); // Day 1 AM - HR: 80
    await db.insertHeartRateUserTestingPast(105, 15); // Day 1 PM - HR: 185
    await db.insertHeartRateUserTestingPast(85, 16); // Day 2 AM - HR: 85
    await db.insertHeartRateUserTestingPast(110, 16); // Day 2 PM - HR: 195
    await db.insertHeartRateUserTestingPast(72, 17); // Day 3 AM - HR: 72
    await db.insertHeartRateUserTestingPast(95, 17); // Day 3 PM - HR: 170
    await db.insertHeartRateUserTestingPast(87, 18); // Day 4 AM - HR: 87
    await db.insertHeartRateUserTestingPast(115, 18); // Day 4 PM - HR: 190
    await db.insertHeartRateUserTestingPast(74, 19); // Day 5 AM - HR: 74
    await db.insertHeartRateUserTestingPast(100, 19); // Day 5 PM - HR: 180
    await db.insertHeartRateUserTestingPast(69, 20); // Day 6 AM - HR: 69
    await db.insertHeartRateUserTestingPast(130, 20); // Day 6 PM - HR: 210
    await db.insertHeartRateUserTestingPast(65, 21); // Day 7 AM - HR: 65
    await db.insertHeartRateUserTestingPast(90, 21); // Day 7 PM - HR: 160

// Week 4 (same days, larger difference on higher heart rate)
    await db.insertHeartRateUserTestingPast(85, 22); // Day 1 AM - HR: 85
    await db.insertHeartRateUserTestingPast(120, 22); // Day 1 PM - HR: 200
    await db.insertHeartRateUserTestingPast(88, 23); // Day 2 AM - HR: 88
    await db.insertHeartRateUserTestingPast(120, 23); // Day 2 PM - HR: 210
    await db.insertHeartRateUserTestingPast(76, 24); // Day 3 AM - HR: 76
    await db.insertHeartRateUserTestingPast(105, 24); // Day 3 PM - HR: 190
    await db.insertHeartRateUserTestingPast(90, 25); // Day 4 AM - HR: 90
    await db.insertHeartRateUserTestingPast(130, 25); // Day 4 PM - HR: 220
    await db.insertHeartRateUserTestingPast(82, 26); // Day 5 AM - HR: 82
    await db.insertHeartRateUserTestingPast(115, 26); // Day 5 PM - HR: 200
    await db.insertHeartRateUserTestingPast(70, 27); // Day 6 AM - HR: 70
    await db.insertHeartRateUserTestingPast(140, 27); // Day 6 PM - HR: 230
    await db.insertHeartRateUserTestingPast(72, 28); // Day 7 AM - HR: 72
    await db.insertHeartRateUserTestingPast(150, 28); // Day 7 PM - HR: 240

    // Insert GSR data for the users with dates
    // Week 1
    await db.insertGSRUserTestingPast(1562, 1); // Day 1 AM - GSR: 25
    await db.insertGSRUserTestingPast(1350, 1); // Day 1 PM - GSR: 350
    await db.insertGSRUserTestingPast(1570, 2); // Day 2 AM - GSR: 30
    await db.insertGSRUserTestingPast(1480, 2); // Day 2 PM - GSR: 400
    await db.insertGSRUserTestingPast(1580, 3); // Day 3 AM - GSR: 34
    await db.insertGSRUserTestingPast(1540, 3); // Day 3 PM - GSR: 450
    await db.insertGSRUserTestingPast(1595, 4); // Day 4 AM - GSR: 38
    await db.insertGSRUserTestingPast(1600, 4); // Day 4 PM - GSR: 500
    await db.insertGSRUserTestingPast(1610, 5); // Day 5 AM - GSR: 42
    await db.insertGSRUserTestingPast(1710, 5); // Day 5 PM - GSR: 550
    await db.insertGSRUserTestingPast(1625, 6); // Day 6 AM - GSR: 46
    await db.insertGSRUserTestingPast(1800, 6); // Day 6 PM - GSR: 650
    await db.insertGSRUserTestingPast(1645, 7); // Day 7 AM - GSR: 50
    await db.insertGSRUserTestingPast(1850, 7); // Day 7 PM - GSR: 700

// Week 2 (same days, larger difference on higher GSR)
    await db.insertGSRUserTestingPast(1575, 8); // Day 1 AM - GSR: 55
    await db.insertGSRUserTestingPast(1600, 8); // Day 1 PM - GSR: 700
    await db.insertGSRUserTestingPast(1580, 9); // Day 2 AM - GSR: 60
    await db.insertGSRUserTestingPast(1680, 9); // Day 2 PM - GSR: 750
    await db.insertGSRUserTestingPast(1595, 10); // Day 3 AM - GSR: 65
    await db.insertGSRUserTestingPast(1700, 10); // Day 3 PM - GSR: 800
    await db.insertGSRUserTestingPast(1605, 11); // Day 4 AM - GSR: 70
    await db.insertGSRUserTestingPast(1730, 11); // Day 4 PM - GSR: 850
    await db.insertGSRUserTestingPast(1620, 12); // Day 5 AM - GSR: 75
    await db.insertGSRUserTestingPast(1750, 12); // Day 5 PM - GSR: 900
    await db.insertGSRUserTestingPast(1640, 13); // Day 6 AM - GSR: 80
    await db.insertGSRUserTestingPast(1800, 13); // Day 6 PM - GSR: 1000
    await db.insertGSRUserTestingPast(1655, 14); // Day 7 AM - GSR: 85
    await db.insertGSRUserTestingPast(1850, 14); // Day 7 PM - GSR: 1100

// Week 3 (same days, larger difference on higher GSR)
    await db.insertGSRUserTestingPast(1590, 15); // Day 1 AM - GSR: 90
    await db.insertGSRUserTestingPast(1750, 15); // Day 1 PM - GSR: 1200
    await db.insertGSRUserTestingPast(1600, 16); // Day 2 AM - GSR: 95
    await db.insertGSRUserTestingPast(1780, 16); // Day 2 PM - GSR: 1300
    await db.insertGSRUserTestingPast(1615, 17); // Day 3 AM - GSR: 100
    await db.insertGSRUserTestingPast(1820, 17); // Day 3 PM - GSR: 1400
    await db.insertGSRUserTestingPast(1625, 18); // Day 4 AM - GSR: 105
    await db.insertGSRUserTestingPast(1850, 18); // Day 4 PM - GSR: 1500
    await db.insertGSRUserTestingPast(1640, 19); // Day 5 AM - GSR: 110
    await db.insertGSRUserTestingPast(1880, 19); // Day 5 PM - GSR: 1600
    await db.insertGSRUserTestingPast(1650, 20); // Day 6 AM - GSR: 115
    await db.insertGSRUserTestingPast(1900, 20); // Day 6 PM - GSR: 1700
    await db.insertGSRUserTestingPast(1670, 21); // Day 7 AM - GSR: 120
    await db.insertGSRUserTestingPast(1950, 21); // Day 7 PM - GSR: 1800

// Week 4 (same days, larger difference on higher GSR)
    await db.insertGSRUserTestingPast(1605, 22); // Day 1 AM - GSR: 130
    await db.insertGSRUserTestingPast(1770, 22); // Day 1 PM - GSR: 1900
    await db.insertGSRUserTestingPast(1625, 23); // Day 2 AM - GSR: 135
    await db.insertGSRUserTestingPast(1800, 23); // Day 2 PM - GSR: 2000
    await db.insertGSRUserTestingPast(1635, 24); // Day 3 AM - GSR: 140
    await db.insertGSRUserTestingPast(1850, 24); // Day 3 PM - GSR: 2100
    await db.insertGSRUserTestingPast(1650, 25); // Day 4 AM - GSR: 145
    await db.insertGSRUserTestingPast(1900, 25); // Day 4 PM - GSR: 2200
    await db.insertGSRUserTestingPast(1670, 26); // Day 5 AM - GSR: 150
    await db.insertGSRUserTestingPast(1950, 26); // Day 5 PM - GSR: 2300
    await db.insertGSRUserTestingPast(1680, 27); // Day 6 AM - GSR: 155
    await db.insertGSRUserTestingPast(2000, 27); // Day 6 PM - GSR: 2400
    await db.insertGSRUserTestingPast(1700, 28); // Day 7 AM - GSR: 160
    await db.insertGSRUserTestingPast(2050, 28); // Day 7 PM - GSR: 2500

    await db.insertSpo2UserTestingPast(98, 1); // Day 1 AM - SpO2: 98%
    await db.insertSpo2UserTestingPast(97, 1); // Day 1 PM - SpO2: 97%

    await db.insertSpo2UserTestingPast(99, 2); // Day 2 AM - SpO2: 99%
    await db.insertSpo2UserTestingPast(98, 2); // Day 2 PM - SpO2: 98%

    await db.insertSpo2UserTestingPast(98, 3); // Day 3 AM - SpO2: 98%
    await db.insertSpo2UserTestingPast(96, 3); // Day 3 PM - SpO2: 96%

    await db.insertSpo2UserTestingPast(99, 4); // Day 4 AM - SpO2: 99%
    await db.insertSpo2UserTestingPast(97, 4); // Day 4 PM - SpO2: 97%

    await db.insertSpo2UserTestingPast(98, 5); // Day 5 AM - SpO2: 98%
    await db.insertSpo2UserTestingPast(96, 5); // Day 5 PM - SpO2: 96%

    await db.insertSpo2UserTestingPast(99, 6); // Day 6 AM - SpO2: 99%
    await db.insertSpo2UserTestingPast(97, 6); // Day 6 PM - SpO2: 97%

    await db.insertSpo2UserTestingPast(98, 7); // Day 7 AM - SpO2: 98%
    await db.insertSpo2UserTestingPast(95, 7); // Day 7 PM - SpO2: 95%

    await db.insertSpo2UserTestingPast(97, 8); // Day 8 AM - SpO2: 97%
    await db.insertSpo2UserTestingPast(96, 8); // Day 8 PM - SpO2: 96%

    await db.insertSpo2UserTestingPast(99, 9); // Day 9 AM - SpO2: 99%
    await db.insertSpo2UserTestingPast(98, 9); // Day 9 PM - SpO2: 98%

    await db.insertSpo2UserTestingPast(97, 10); // Day 10 AM - SpO2: 97%
    await db.insertSpo2UserTestingPast(96, 10); // Day 10 PM - SpO2: 96%

    await db.insertSpo2UserTestingPast(98, 11); // Day 11 AM - SpO2: 98%
    await db.insertSpo2UserTestingPast(97, 11); // Day 11 PM - SpO2: 97%

    await db.insertSpo2UserTestingPast(99, 12); // Day 12 AM - SpO2: 99%
    await db.insertSpo2UserTestingPast(98, 12); // Day 12 PM - SpO2: 98%

    await db.insertSpo2UserTestingPast(97, 13); // Day 13 AM - SpO2: 97%
    await db.insertSpo2UserTestingPast(95, 13); // Day 13 PM - SpO2: 95%

    await db.insertSpo2UserTestingPast(99, 14); // Day 14 AM - SpO2: 99%
    await db.insertSpo2UserTestingPast(97, 14); // Day 14 PM - SpO2: 97%

    await db.insertSpo2UserTestingPast(98, 15); // Day 15 AM - SpO2: 98%
    await db.insertSpo2UserTestingPast(96, 15); // Day 15 PM - SpO2: 96%

    await db.insertSpo2UserTestingPast(99, 16); // Day 16 AM - SpO2: 99%
    await db.insertSpo2UserTestingPast(97, 16); // Day 16 PM - SpO2: 97%

    await db.insertSpo2UserTestingPast(98, 17); // Day 17 AM - SpO2: 98%
    await db.insertSpo2UserTestingPast(96, 17); // Day 17 PM - SpO2: 96%

    await db.insertSpo2UserTestingPast(99, 18); // Day 18 AM - SpO2: 99%
    await db.insertSpo2UserTestingPast(97, 18); // Day 18 PM - SpO2: 97%

    await db.insertSpo2UserTestingPast(97, 19); // Day 19 AM - SpO2: 97%
    await db.insertSpo2UserTestingPast(96, 19); // Day 19 PM - SpO2: 96%

    await db.insertSpo2UserTestingPast(98, 20); // Day 20 AM - SpO2: 98%
    await db.insertSpo2UserTestingPast(97, 20); // Day 20 PM - SpO2: 97%

    await db.insertSpo2UserTestingPast(99, 21); // Day 21 AM - SpO2: 99%
    await db.insertSpo2UserTestingPast(98, 21); // Day 21 PM - SpO2: 98%

    await db.insertSpo2UserTestingPast(98, 22); // Day 22 AM - SpO2: 98%
    await db.insertSpo2UserTestingPast(96, 22); // Day 22 PM - SpO2: 96%

    await db.insertSpo2UserTestingPast(99, 23); // Day 23 AM - SpO2: 99%
    await db.insertSpo2UserTestingPast(97, 23); // Day 23 PM - SpO2: 97%

    await db.insertSpo2UserTestingPast(98, 24); // Day 24 AM - SpO2: 98%
    await db.insertSpo2UserTestingPast(95, 24); // Day 24 PM - SpO2: 95%

    await db.insertSpo2UserTestingPast(99, 25); // Day 25 AM - SpO2: 99%
    await db.insertSpo2UserTestingPast(97, 25); // Day 25 PM - SpO2: 97%

    await db.insertSpo2UserTestingPast(98, 26); // Day 26 AM - SpO2: 98%
    await db.insertSpo2UserTestingPast(96, 26); // Day 26 PM - SpO2: 96%

    await db.insertSpo2UserTestingPast(99, 27); // Day 27 AM - SpO2: 99%
    await db.insertSpo2UserTestingPast(97, 27); // Day 27 PM - SpO2: 97%

    await db.insertSpo2UserTestingPast(98, 28); // Day 28 AM - SpO2: 98%
    await db.insertSpo2UserTestingPast(96, 28); // Day 28 PM - SpO2: 96%

    await db.insertSpo2UserTestingPast(99, 29); // Day 29 AM - SpO2: 99%
    await db.insertSpo2UserTestingPast(97, 29); // Day 29 PM - SpO2: 97%

    await db.insertSpo2UserTestingPast(98, 30); // Day 30 AM - SpO2: 98%
    await db.insertSpo2UserTestingPast(96, 30); // Day 30 PM - SpO2: 96%

    await db.insertRespiratoryRatePast(
        12, 1); // Day 1 AM - Respiratory Rate: 12 bpm
    await db.insertRespiratoryRatePast(
        14, 1); // Day 1 PM - Respiratory Rate: 14 bpm

    await db.insertRespiratoryRatePast(
        13, 2); // Day 2 AM - Respiratory Rate: 13 bpm
    await db.insertRespiratoryRatePast(
        15, 2); // Day 2 PM - Respiratory Rate: 15 bpm

    await db.insertRespiratoryRatePast(
        14, 3); // Day 3 AM - Respiratory Rate: 14 bpm
    await db.insertRespiratoryRatePast(
        16, 3); // Day 3 PM - Respiratory Rate: 16 bpm

    await db.insertRespiratoryRatePast(
        15, 4); // Day 4 AM - Respiratory Rate: 15 bpm
    await db.insertRespiratoryRatePast(22,
        4); // Day 4 PM - Respiratory Rate: 22 bpm (larger difference on Thursday)

    await db.insertRespiratoryRatePast(
        18, 5); // Day 5 AM - Respiratory Rate: 18 bpm
    await db.insertRespiratoryRatePast(
        19, 5); // Day 5 PM - Respiratory Rate: 19 bpm

    await db.insertRespiratoryRatePast(
        17, 6); // Day 6 AM - Respiratory Rate: 17 bpm
    await db.insertRespiratoryRatePast(
        19, 6); // Day 6 PM - Respiratory Rate: 19 bpm

    await db.insertRespiratoryRatePast(
        16, 7); // Day 7 AM - Respiratory Rate: 16 bpm
    await db.insertRespiratoryRatePast(
        18, 7); // Day 7 PM - Respiratory Rate: 18 bpm

    await db.insertRespiratoryRatePast(
        14, 8); // Day 8 AM - Respiratory Rate: 14 bpm
    await db.insertRespiratoryRatePast(
        18, 8); // Day 8 PM - Respiratory Rate: 18 bpm

    await db.insertRespiratoryRatePast(
        17, 9); // Day 9 AM - Respiratory Rate: 17 bpm
    await db.insertRespiratoryRatePast(
        20, 9); // Day 9 PM - Respiratory Rate: 20 bpm

    await db.insertRespiratoryRatePast(
        19, 10); // Day 10 AM - Respiratory Rate: 19 bpm
    await db.insertRespiratoryRatePast(
        21, 10); // Day 10 PM - Respiratory Rate: 21 bpm

    await db.insertRespiratoryRatePast(
        20, 11); // Day 11 AM - Respiratory Rate: 20 bpm
    await db.insertRespiratoryRatePast(26,
        11); // Day 11 PM - Respiratory Rate: 26 bpm (larger difference on Thursday)

    await db.insertRespiratoryRatePast(
        22, 12); // Day 12 AM - Respiratory Rate: 22 bpm
    await db.insertRespiratoryRatePast(
        23, 12); // Day 12 PM - Respiratory Rate: 23 bpm

    await db.insertRespiratoryRatePast(
        20, 13); // Day 13 AM - Respiratory Rate: 24 bpm
    await db.insertRespiratoryRatePast(
        22, 13); // Day 13 PM - Respiratory Rate: 27 bpm

    await db.insertRespiratoryRatePast(
        23, 14); // Day 14 AM - Respiratory Rate: 23 bpm
    await db.insertRespiratoryRatePast(
        21, 14); // Day 14 PM - Respiratory Rate: 21 bpm

    await db.insertRespiratoryRatePast(
        22, 15); // Day 15 AM - Respiratory Rate: 22 bpm
    await db.insertRespiratoryRatePast(
        20, 15); // Day 15 PM - Respiratory Rate: 20 bpm

    await db.insertRespiratoryRatePast(
        21, 16); // Day 16 AM - Respiratory Rate: 21 bpm
    await db.insertRespiratoryRatePast(
        19, 16); // Day 16 PM - Respiratory Rate: 19 bpm

    await db.insertRespiratoryRatePast(
        19, 17); // Day 17 AM - Respiratory Rate: 19 bpm
    await db.insertRespiratoryRatePast(
        17, 17); // Day 17 PM - Respiratory Rate: 17 bpm

    await db.insertRespiratoryRatePast(
        10, 18); // Day 18 AM - Respiratory Rate: 18 bpm
    await db.insertRespiratoryRatePast(
        18, 18); // Day 18 PM - Respiratory Rate: 16 bpm

    await db.insertRespiratoryRatePast(
        17, 19); // Day 19 AM - Respiratory Rate: 17 bpm
    await db.insertRespiratoryRatePast(
        16, 19); // Day 19 PM - Respiratory Rate: 16 bpm

    await db.insertRespiratoryRatePast(
        16, 20); // Day 20 AM - Respiratory Rate: 16 bpm
    await db.insertRespiratoryRatePast(
        14, 20); // Day 20 PM - Respiratory Rate: 14 bpm

    await db.insertRespiratoryRatePast(
        15, 21); // Day 21 AM - Respiratory Rate: 15 bpm
    await db.insertRespiratoryRatePast(
        13, 21); // Day 21 PM - Respiratory Rate: 13 bpm

    await db.insertRespiratoryRatePast(
        14, 22); // Day 22 AM - Respiratory Rate: 14 bpm
    await db.insertRespiratoryRatePast(
        12, 22); // Day 22 PM - Respiratory Rate: 12 bpm

    await db.insertRespiratoryRatePast(
        12, 23); // Day 23 AM - Respiratory Rate: 12 bpm
    await db.insertRespiratoryRatePast(
        10, 23); // Day 23 PM - Respiratory Rate: 10 bpm

    await db.insertRespiratoryRatePast(
        10, 24); // Day 24 AM - Respiratory Rate: 10 bpm
    await db.insertRespiratoryRatePast(
        8, 24); // Day 24 PM - Respiratory Rate: 8 bpm

    await db.insertRespiratoryRatePast(
        9, 25); // Day 25 AM - Respiratory Rate: 9 bpm
    await db.insertRespiratoryRatePast(
        15, 25); // Day 25 PM - Respiratory Rate: 8 bpm

    await db.insertRespiratoryRatePast(
        8, 26); // Day 26 AM - Respiratory Rate: 8 bpm
    await db.insertRespiratoryRatePast(
        7, 26); // Day 26 PM - Respiratory Rate: 7 bpm

    await db.insertRespiratoryRatePast(
        7, 27); // Day 27 AM - Respiratory Rate: 7 bpm
    await db.insertRespiratoryRatePast(
        6, 27); // Day 27 PM - Respiratory Rate: 6 bpm

    await db.insertRespiratoryRatePast(
        6, 28); // Day 28 AM - Respiratory Rate: 6 bpm
    await db.insertRespiratoryRatePast(
        5, 28); // Day 28 PM - Respiratory Rate: 5 bpm

    await db.insertRespiratoryRatePast(
        5, 29); // Day 29 AM - Respiratory Rate: 5 bpm
    await db.insertRespiratoryRatePast(
        4, 29); // Day 29 PM - Respiratory Rate: 4 bpm

    await db.insertRespiratoryRatePast(
        4, 30); // Day 30 AM - Respiratory Rate: 4 bpm
    await db.insertRespiratoryRatePast(
        3, 30); // Day 30 PM - Respiratory Rate: 3 bpm

    print("Sample data with dates inserted!");
  }

  @override
  Widget build(BuildContext context) {
    AppDatabase database = widget.bluetooth.getDatabase();
    String currentUser = database.getCurrentUser();

    if (widget.isNewUser) {
      return homePageNewUser(context, widget.bluetooth);
    } else {
      return ChangeNotifierProvider.value(
        value: widget.bluetooth,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 148, 204, 250),
          appBar: AppBar(
            title: Text("Stress Monitoring of $currentUser"),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back), // Standard back arrow
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserSelection(
                            bluetooth: widget.bluetooth,
                          )), // Replace with your target page
                );
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.bluetooth),
                onPressed: () => showBluetoothScanPage(context),
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            child: ListView(
              children: [
                const SizedBox(height: 20),
                // Floating action button to start/stop measurement
                Consumer<Bluetooth>(
                  builder: (context, bluetooth, _) {
                    return FloatingActionButton(
                      child: const Text("Start measurement"),
                      onPressed: () async {
                        if (bluetooth.connectedDevice == null) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: const Text("No Device Connected"),
                                    content: const Text(
                                        "Please connect to a device to start measurement"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("OK"),
                                      ),
                                    ],
                                  ));
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: bluetooth.connectedDevice != null
                                        ? const Text(
                                            "Select parameters to measure")
                                        : const Text("No Device Connected"),
                                    content: bluetooth.connectedDevice != null
                                        ? const Text("")
                                        : const Text("No Device Connected"),
                                    actions: [
                                      Column(
                                        children: [
                                          const Text(
                                              "Grab the right sensor and press the parameter you want to measure"),
                                          const SizedBox(
                                            height: 60,
                                          ),
                                          Row(
                                            children: [
                                              const Spacer(),
                                              Container(
                                                width: 100,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.blue,
                                                ),
                                                child: TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context); // Close the current dialog
                                                    Future.delayed(
                                                        Duration.zero, () {
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false, // Prevent closing manually
                                                        builder: (context) {
                                                          // Start measurement after build completes
                                                          WidgetsBinding
                                                              .instance
                                                              .addPostFrameCallback(
                                                                  (_) {
                                                            bluetooth
                                                                .startMeasurement(
                                                              Provider.of<
                                                                      SensorData>(
                                                                  context,
                                                                  listen:
                                                                      false),
                                                            );
                                                          });

                                                          // Set up a listener to close the dialog when measurement is done
                                                          bluetooth
                                                              .addListener(() {
                                                            if (!bluetooth
                                                                    .isMeasuring &&
                                                                Navigator.canPop(
                                                                    context)) {
                                                              final sensorData =
                                                                  Provider.of<
                                                                          SensorData>(
                                                                      context,
                                                                      listen:
                                                                          false);
                                                              if (sensorData
                                                                          .heartRate ==
                                                                      -999 ||
                                                                  sensorData
                                                                          .spo2 ==
                                                                      -999) {
                                                                // Measurement failed
                                                                Navigator.pop(
                                                                    context); // Close the "Measuring..." dialog
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  barrierDismissible:
                                                                      false,
                                                                  builder:
                                                                      (context) =>
                                                                          AlertDialog(
                                                                    title: const Text(
                                                                        "Measurement Failed"),
                                                                    content:
                                                                        const Text(
                                                                            "Heart rate or SpO2 measurement failed. Please measure these parameters separate."),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context); // Close the "Measurement Failed" dialog
                                                                        },
                                                                        child: const Text(
                                                                            "OK"),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              } else {
                                                                // Measurement succeeded, close the dialog
                                                                Navigator.pop(
                                                                    context); // Close the "Measuring..." dialog
                                                              }
                                                              bluetooth
                                                                  .removeListener(
                                                                      () {}); // Clean up
                                                            }
                                                          });

                                                          return const AlertDialog(
                                                            title: Text(
                                                                "Measuring..."),
                                                            content: SizedBox(
                                                              height: 60,
                                                              child: Center(
                                                                  child:
                                                                      CircularProgressIndicator()),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    });
                                                  },
                                                  child: const Text(
                                                    "All",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              Container(
                                                width: 100,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.blue,
                                                ),
                                                child: TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context); // Close the current dialog
                                                    Future.delayed(
                                                        Duration.zero, () {
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false, // Prevent closing manually
                                                        builder: (context) {
                                                          // Start measurement after build completes
                                                          WidgetsBinding
                                                              .instance
                                                              .addPostFrameCallback(
                                                                  (_) {
                                                            bluetooth
                                                                .startHeartMeasurement(
                                                              Provider.of<
                                                                      SensorData>(
                                                                  context,
                                                                  listen:
                                                                      false),
                                                            );
                                                          });

                                                          // Set up a listener to close the dialog when measurement is done
                                                          bluetooth
                                                              .addListener(() {
                                                            if (!bluetooth
                                                                    .isMeasuring &&
                                                                Navigator.canPop(
                                                                    context)) {
                                                              if (Provider.of<SensorData>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .heartRate ==
                                                                  -999) {
                                                                // Measurement failed
                                                                Navigator.pop(
                                                                    context); // Close the "Measuring..." dialog
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  barrierDismissible:
                                                                      false,
                                                                  builder:
                                                                      (context) =>
                                                                          AlertDialog(
                                                                    title: const Text(
                                                                        "Measurement Failed"),
                                                                    content:
                                                                        const Text(
                                                                            "Heart rate measurement failed. Please try again."),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context); // Close the "Measurement Failed" dialog
                                                                        },
                                                                        child: const Text(
                                                                            "OK"),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              } else {
                                                                // Measurement succeeded, close the dialog
                                                                Navigator.pop(
                                                                    context); // Close the "Measuring..." dialog
                                                              }
                                                              bluetooth
                                                                  .removeListener(
                                                                      () {}); // Clean up
                                                            }
                                                          });

                                                          return const AlertDialog(
                                                            title: Text(
                                                                "Measuring..."),
                                                            content: SizedBox(
                                                              height: 60,
                                                              child: Center(
                                                                  child:
                                                                      CircularProgressIndicator()),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    });
                                                  },
                                                  child: const Text(
                                                    "Heart Rate",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              const Spacer(),
                                              Container(
                                                width: 100,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.blue,
                                                ),
                                                child: TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context); // Close the current dialog
                                                    Future.delayed(
                                                        Duration.zero, () {
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false, // Prevent closing manually
                                                        builder: (context) {
                                                          // Start measurement after build completes
                                                          WidgetsBinding
                                                              .instance
                                                              .addPostFrameCallback(
                                                                  (_) {
                                                            bluetooth
                                                                .startSpo2Measurement(
                                                              Provider.of<
                                                                      SensorData>(
                                                                  context,
                                                                  listen:
                                                                      false),
                                                            );
                                                          });

                                                          // Set up a listener to close the dialog when measurement is done
                                                          bluetooth
                                                              .addListener(() {
                                                            if (!bluetooth
                                                                    .isMeasuring &&
                                                                Navigator.canPop(
                                                                    context)) {
                                                              if (Provider.of<SensorData>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .spo2 ==
                                                                  -999) {
                                                                // Measurement failed
                                                                Navigator.pop(
                                                                    context); // Close the "Measuring..." dialog
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  barrierDismissible:
                                                                      false,
                                                                  builder:
                                                                      (context) =>
                                                                          AlertDialog(
                                                                    title: const Text(
                                                                        "Measurement Failed"),
                                                                    content:
                                                                        const Text(
                                                                            "SpO2 measurement failed. Please try again."),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context); // Close the "Measurement Failed" dialog
                                                                        },
                                                                        child: const Text(
                                                                            "OK"),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              } else {
                                                                // Measurement succeeded, close the dialog
                                                                Navigator.pop(
                                                                    context); // Close the "Measuring..." dialog
                                                              }
                                                              bluetooth
                                                                  .removeListener(
                                                                      () {}); // Clean up
                                                            }
                                                          });

                                                          return const AlertDialog(
                                                            title: Text(
                                                                "Measuring..."),
                                                            content: SizedBox(
                                                              height: 60,
                                                              child: Center(
                                                                  child:
                                                                      CircularProgressIndicator()),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    });
                                                  },
                                                  child: const Text(
                                                    "Spo2",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              Container(
                                                width: 100,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.blue,
                                                ),
                                                child: TextButton(
                                                  onPressed: () => {
                                                    Navigator.pop(
                                                        context), // Close the dialog
                                                    // Close the dialog
                                                    Future.delayed(
                                                        Duration.zero, () {
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false, // Prevent closing manually
                                                        builder: (context) {
                                                          // Start measurement after build completes
                                                          WidgetsBinding
                                                              .instance
                                                              .addPostFrameCallback(
                                                                  (_) {
                                                            bluetooth
                                                                .startGSRMeasurement(
                                                              Provider.of<
                                                                      SensorData>(
                                                                  context,
                                                                  listen:
                                                                      false),
                                                            );
                                                          });

                                                          // Set up a listener to close the dialog when measurement is done
                                                          bluetooth
                                                              .addListener(() {
                                                            if (!bluetooth
                                                                    .isMeasuring &&
                                                                Navigator.canPop(
                                                                    context)) {
                                                              Navigator.pop(
                                                                  context); // Close the "Measuring..." dialog
                                                              bluetooth
                                                                  .removeListener(
                                                                      () {}); // Clean up
                                                            }
                                                          });

                                                          return const AlertDialog(
                                                            title: Text(
                                                                "Measuring..."),
                                                            content: SizedBox(
                                                              height: 60,
                                                              child: Center(
                                                                  child:
                                                                      CircularProgressIndicator()),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    })
                                                  },
                                                  child: const Text(
                                                    "GSR",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: 100,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.blue,
                                            ),
                                            child: TextButton(
                                              onPressed: () => {
                                                Navigator.pop(
                                                    context), // Close the dialog
                                                // Close the dialog
                                                Future.delayed(Duration.zero,
                                                    () {
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible:
                                                        false, // Prevent closing manually
                                                    builder: (context) {
                                                      // Start measurement after build completes
                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (_) {
                                                        bluetooth
                                                            .startBreathingMeasurement(
                                                          Provider.of<
                                                                  SensorData>(
                                                              context,
                                                              listen: false),
                                                        );
                                                      });

                                                      // Set up a listener to close the dialog when measurement is done
                                                      bluetooth.addListener(() {
                                                        if (!bluetooth
                                                                .isMeasuring &&
                                                            Navigator.canPop(
                                                                context)) {
                                                          Navigator.pop(
                                                              context); // Close the "Measuring..." dialog
                                                          bluetooth.removeListener(
                                                              () {}); // Clean up
                                                        }
                                                      });

                                                      return const AlertDialog(
                                                        title: Text(
                                                            "Measuring..."),
                                                        content: SizedBox(
                                                          height: 60,
                                                          child: Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                })
                                              },
                                              child: const Text(
                                                "Respiration",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ));
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Listen to the SensorData changes using Consumer
                Consumer<SensorData>(builder: (context, sensorData, _) {
                  return Column(
                    children: [
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: FloatingActionButton(
                            child: const Text("Print data amount (debug)"),
                            onPressed: () async {
                              await insertSampleDataWithDate(database);
                            }),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 300,
                        height: 60,
                        child: StressIndicator(sensorData.gsr, database),
                      ),
                      const SizedBox(height: 20),
                      SensorCardsPager(
                        minHeartValue: minHeartValue,
                        maxHeartValue: maxHeartValue,
                        minGSRValue: minGSRValue,
                        maxGSRValue: maxGSRValue,
                        sensorData: sensorData,
                        bluetooth: widget.bluetooth,
                        onHeartConfig: () =>
                            navigateToConfiguringHeartPage(context),
                        onGSRConfig: () =>
                            navigateToConfiguringGSRPage(context),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      );
    }
  }

  Scaffold homePageNewUser(BuildContext context, Bluetooth bluetooth) {
    final PageController pageController = PageController();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 148, 204, 250),
      appBar: AppBar(
        title: const Text("Configuring new user"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Standard back arrow
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => UserSelection(
                        bluetooth: widget.bluetooth,
                      )), // Replace with your target page
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bluetooth),
            onPressed: () => showBluetoothScanPage(context),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 560,
                    width: 350,
                    child: PagerWidget(controller: pageController, pages: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          border: Border.all(color: Colors.black, width: 3),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Text("Measurement configuration",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 40),
                              Text(
                                "As a new user a configuration for the heart rate, respiration rate and GSR is needed. In this step your average heart rate and GSR will be measured to later make the right assessments. Please make sure that the device is connected to the app.",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          border: Border.all(color: Colors.black, width: 3),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Text("Step 1: Respiration rate sensor ",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 20),
                              Text(
                                  "Place the sensor securely around your chest. Make sure it fits snugly but is still comfortable.\n\n When doing the measurement, sit down comfortably. Try to remain still during the calibration process and breath normally. There is no need to change your breathing pattern. \n\n The respiratory rate sensor will measure for a minute to get your respiratory rate while resting.",
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          border: Border.all(color: Colors.black, width: 3),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Text("Step 2: GSR sensor ",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 20),
                              Text(
                                  "The GSR sensor measures the electrical conductance of the skin (how much sweat is on the skin). This is a good indicator of stress. Take the two wrappers (sensor pads) and place them on the index and middle finger. After the measurement is started, the sensor will measure your GSR until it has enough data to take an average reading from.",
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          border: Border.all(color: Colors.black, width: 3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              const Text("Step 3: Heart rate sensor",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 20),
                              const Text(
                                  "Take the heart rate sensor. Place the red light in between your thumb and index finger. Use some light but constant pressure on the led. This is important to get a good reading. After the measurement is started, the sensor will measure your heart rate until it has enough data to take an average reading from.",
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                              const SizedBox(height: 70),
                              SizedBox(
                                width: 200,
                                height: 60,
                                child: FloatingActionButton(
                                  onPressed: () async {
                                    if (bluetooth.connectedDevice == null) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title: const Text(
                                                    "No Device Connected"),
                                                content: const Text(
                                                    "Please connect to a device to start measurement"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text("OK"),
                                                  ),
                                                ],
                                              ));
                                    } else {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) =>
                                            const AlertDialog(
                                          title: Text("Configuring values"),
                                          content: Text(
                                              "Measuring resting respiratory rate, average heart rate and GSR... \n\n This may take a few minutes. Please wait."),
                                        ),
                                      );
                                      final avgHeartRate =
                                          await bluetooth.getAverageHeartRate();
                                      final avgGSR =
                                          await bluetooth.getAverageGSR();
                                      final restingRespirationRate =
                                          await bluetooth
                                              .getRestingRespiration();

                                      bluetooth
                                          .getDatabase()
                                          .updateAverageHeartRate(avgHeartRate);
                                      bluetooth
                                          .getDatabase()
                                          .updateAverageGSR(avgGSR);
                                      bluetooth
                                          .getDatabase()
                                          .updateRestingRespiratoryRate(
                                              restingRespirationRate);
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                    title: const Text(
                                                        "Configuration complete"),
                                                    content: const Text(
                                                        "All values are measured. Press the 'home' button to go to the homescreen."),
                                                    actions: [
                                                      FloatingActionButton(
                                                        onPressed: () async {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      HomeScreen(
                                                                bluetooth:
                                                                    bluetooth,
                                                                isNewUser:
                                                                    false,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: const SizedBox(
                                                            height: 40,
                                                            width: 140,
                                                            child: Center(
                                                                child: Text(
                                                                    "Home"))),
                                                      ),
                                                    ]));
                                      }
                                    }
                                  },
                                  child: const Text("Start configuration"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SmoothPageIndicator(
                      controller: pageController,
                      count: 4,
                      effect: const WormEffect(
                          activeDotColor: Colors
                              .black), // or JumpingDotEffect, ExpandingDotsEffect etc.
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
