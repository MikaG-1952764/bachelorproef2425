import 'package:flutter/material.dart';
import 'package:stress_measurement_app/Models/bluetooth.dart';
import 'package:stress_measurement_app/Models/database.dart';
import 'package:stress_measurement_app/UI/homescreen.dart';

class UserSelection extends StatelessWidget {
  const UserSelection({super.key, required this.bluetooth});
  final Bluetooth bluetooth;

  @override
  Widget build(BuildContext context) {
    final userSelectionController = TextEditingController();
    final ageController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Selection"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Select User",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(width: 1.0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: userSelectionController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 50,
              child: FloatingActionButton(
                child: const Text("Continue"),
                onPressed: () async {
                  String selectedUser =
                      userSelectionController.text.trim().toLowerCase();

                  if (selectedUser.isNotEmpty) {
                    AppDatabase database = bluetooth.getDatabase();

                    int? existingUserId =
                        await database.getUserIdFromUsername(selectedUser);

                    if (existingUserId != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text("User $selectedUser found in database")),
                      );
                      database.setCurrentUser(selectedUser);
                      int userCount = await database.getCurrentAmount();
                      print("Current user amount: $userCount");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(
                            bluetooth: bluetooth,
                            isNewUser: false,
                          ),
                        ),
                      );
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text("Adding new user"),
                                actions: [
                                  Column(
                                    children: [
                                      const Text("Age"),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        width: 200,
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: TextField(
                                          controller: ageController,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 12.0,
                                                    vertical: 8.0),
                                          ),
                                          keyboardType: TextInputType.text,
                                        ),
                                      ),
                                      ElevatedButton(
                                          onPressed: () async {
                                            int maxHeartRate = (208 -
                                                    (0.7 *
                                                        double.parse(
                                                            ageController
                                                                .text)))
                                                .toInt();
                                            await database.insertUser(
                                                selectedUser, maxHeartRate);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "User $selectedUser added")),
                                            );
                                            database
                                                .setCurrentUser(selectedUser);
                                            int userCount = await database
                                                .getCurrentAmount();
                                            print(
                                                "Current user amount: ${database.getCurrentUser()}");
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen(
                                                  bluetooth: bluetooth,
                                                  isNewUser: true,
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text("Add")),
                                    ],
                                  )
                                ],
                              ));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select a user")),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 50,
              child: FloatingActionButton(
                  child: const Text("Delete complete database data"),
                  onPressed: () {
                    bluetooth.getDatabase().deleteAllData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("All data deleted")),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
