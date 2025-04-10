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
  IntColumn get maxHeartRate => integer().nullable()();
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

  String getCurrentUser() {
    return userName ?? "No user selected";
  }

  Future<void> deleteAllData() async {
    await delete(users).go();
    await delete(heartRate).go();
    await delete(gsr).go();
    await delete(spo2).go();
    await delete(stressLevel).go();
  }

  Future<int> getCurrentAmount() async {
    final countExpression = users.id.count();
    final query = selectOnly(users)..addColumns([countExpression]);
    final result =
        await query.map((row) => row.read(countExpression) ?? 0).getSingle();
    return result;
  }

  // Insert user
  Future<int> insertUser(String name, int maxHeartRate) async {
    return into(users).insert(
        UsersCompanion(name: Value(name), maxHeartRate: Value(maxHeartRate)));
  }

  Future<int?> getCurrentUserMaxHeartRate() async {
    if (userId == null) return null;

    final result = await (select(users)..where((u) => u.id.equals(userId!)))
        .getSingleOrNull();

    return result?.maxHeartRate;
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

  Future<int> getHeartRateCount() async {
    final countExpression = heartRate.id.count();
    final query = selectOnly(heartRate)..addColumns([countExpression]);
    final result =
        await query.map((row) => row.read(countExpression) ?? 0).getSingle();
    return result;
  }

  Future<List<String>> getAllUserNames() async {
    final query = select(users).map((user) => user.name);
    return query.get();
  }

  Future<String?> getUser(String userName) async {
    final result = await (select(users)..where((t) => t.name.equals(userName)))
        .getSingleOrNull();
    return result?.name;
  }

  // Get heart rate data for a user
  Future<List<HeartRateData>> getUserHeartRates(int userId) async {
    return (select(heartRate)..where((t) => t.userId.equals(userId))).get();
  }

  Future<List<Map<String, dynamic>>> getLatestHeartRateReadings(
      int limit) async {
    if (userId == null) {
      return []; // No user selected, return an empty list
    }

    final query = (select(heartRate)
      ..where((t) => t.userId.equals(userId!))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(limit));

    final results = await query.map((row) {
      return {
        'date': row.createdAt
            .toString()
            .split(' ')[0], // Extract only the date part
        'heartRate': row.heartRate,
      };
    }).get();

    return results;
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

  Future<List<Map<String, dynamic>>> getLatestGSRReadings(int limit) async {
    if (userId == null) {
      return []; // No user selected, return an empty list
    }

    final query = (select(gsr)
      ..where((t) => t.userId.equals(userId!))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(limit));

    final results = await query.map((row) {
      return {
        'date': row.createdAt
            .toString()
            .split(' ')[0], // Extract only the date part
        'gsr': row.gsr,
      };
    }).get();

    return results;
  }

  Future<int> getGSRCount() async {
    final countExpression = gsr.id.count();
    final query = selectOnly(gsr)..addColumns([countExpression]);
    final result =
        await query.map((row) => row.read(countExpression) ?? 0).getSingle();
    return result;
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

  Future<List<Map<String, dynamic>>> getLatestSpo2Readings(int limit) async {
    if (userId == null) {
      print("No user selected, returning empty list.");
      return []; // No user selected, return an empty list
    }

    final query = (select(spo2)
      ..where((t) => t.userId.equals(userId!))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(limit));

    final results = await query.map((row) {
      return {
        'date': row.createdAt
            .toString()
            .split(' ')[0], // Extract only the date part
        'spo2': row.spo2,
      };
    }).get();
    return results;
  }

  Future<int> getSpo2Count() async {
    final countExpression = spo2.id.count();
    final query = selectOnly(spo2)..addColumns([countExpression]);
    final result =
        await query.map((row) => row.read(countExpression) ?? 0).getSingle();
    return result;
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

  Future<List<Map<String, dynamic>>> getGSRReadingsInRange(
      DateTime startDate, DateTime endDate) async {
    if (userId == null) {
      return []; // No user selected, return an empty list
    }

    final query = (select(gsr)
      ..where((t) => t.userId.equals(userId!))
      ..where((t) => t.createdAt.isBetweenValues(startDate, endDate))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]));

    final results = await query.map((row) {
      return {
        'date': row.createdAt
            .toString()
            .split(' ')[0], // Extract only the date part
        'gsr': row.gsr,
      };
    }).get();

    return results;
  }

  Future<List<Map<String, dynamic>>> getHeartRateReadingsInRange(
      DateTime startDate, DateTime endDate) async {
    if (userId == null) {
      return []; // No user selected, return an empty list
    }

    final query = (select(heartRate)
      ..where((t) => t.userId.equals(userId!))
      ..where((t) => t.createdAt.isBetweenValues(startDate, endDate))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]));

    final results = await query.map((row) {
      return {
        'date': row.createdAt
            .toString()
            .split(' ')[0], // Extract only the date part
        'heartRate': row.heartRate,
      };
    }).get();

    return results;
  }

  Future<List<Map<String, dynamic>>> getSpo2ReadingsInRange(
      DateTime startDate, DateTime endDate) async {
    if (userId == null) {
      return []; // No user selected, return an empty list
    }

    final query = (select(spo2)
      ..where((t) => t.userId.equals(userId!))
      ..where((t) => t.createdAt.isBetweenValues(startDate, endDate))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]));

    final results = await query.map((row) {
      return {
        'date': row.createdAt
            .toString()
            .split(' ')[0], // Extract only the date part
        'spo2': row.spo2,
      };
    }).get();

    return results;
  }
}
