import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'database.g.dart';

String? userName = null;
int? userId = null;

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().named('Your name')();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

class HeartRate extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)(); // Foreign key
  IntColumn get heartRate => integer()();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

class GSR extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  IntColumn get gsr => integer()();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

class SPO2 extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  IntColumn get spo2 => integer()();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

class StressLevel extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  IntColumn get stressLevel => integer()();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

@DriftDatabase(tables: [Users, HeartRate, GSR, SPO2, StressLevel])
class AppDatabase extends _$AppDatabase {
  Future<void> setCurrentUser(String username) async {
    userName = username;
    userId = await getUserIdFromUsername(username);
  }

  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(
          p.join(dbFolder.path, 'stress_measurements_application_data.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }

  // Insert user
  Future<int> insertUser(String name) async {
    return into(users).insert(UsersCompanion(name: Value(name)));
  }

  // Insert heart rate data
  Future<int> insertHeartRate(int measuredHeartRate) async {
    return into(heartRate).insert(
      HeartRateCompanion(
        userId: Value(userId!),
        heartRate: Value(measuredHeartRate),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  // Get heart rate data for a user
  Future<List<HeartRateData>> getUserHeartRates(int userId) async {
    return (select(heartRate)..where((t) => t.userId.equals(userId))).get();
  }

  Future<int> insertGSR(int measuredGSR) async {
    return into(gsr).insert(
      GSRCompanion(
        userId: Value(userId!),
        gsr: Value(measuredGSR),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  // Get heart rate data for a user
  Future<List<GSRData>> getGSRs(int userId) async {
    return (select(gsr)..where((t) => t.userId.equals(userId))).get();
  }

  Future<int> insertSpo2(int measuredSpo2) async {
    return into(spo2).insert(
      SPO2Companion(
        userId: Value(userId!),
        spo2: Value(measuredSpo2),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  // Get heart rate data for a user
  Future<List<SPO2Data>> getSpo2s(int userId) async {
    return (select(spo2)..where((t) => t.userId.equals(userId))).get();
  }

  Future<int?> getUserIdFromUsername(String username) async {
    final result =
        await (select(users)..where((tbl) => tbl.name.equals(username))).get();

    if (result.isNotEmpty) {
      return result.first.id; // Return the userId of the first matching user
    } else {
      return null; // If no user with that username was found
    }
  }
}
