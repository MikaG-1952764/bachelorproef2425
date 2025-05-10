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
                                                  onPressed: () => {
                                                    Navigator.pop(
                                                        context), // Close the dialog
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
                      /*SizedBox(
                        width: 300,
                        height: 50,
                        child: FloatingActionButton(
                            child: const Text("Print data amount (debug)"),
                            onPressed: () async {
                              final avgHeartRate = await widget.bluetooth
                                  .getDatabase()
                                  .getCurrentUserAverageHeartRate();
                              final avgGSR = await widget.bluetooth
                                  .getDatabase()
                                  .getCurrentUserAverageGSR();
                              print(
                                  "Average heart rate out of database: ${avgHeartRate}");
                              print("Average GSR out of database: ${avgGSR}");
                            }),
                      ),*/
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
        title: const Text("Cofiguring new user"),
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
