import 'package:moor_flutter/moor_flutter.dart';
import 'package:smarthome/database/entities/devices.dart';

part 'database.g.dart';

@UseMoor(tables: [Devices])
class MyDatabase extends _$MyDatabase {
  MyDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(path: 'db.sqlite'));

  @override
  int get schemaVersion => 1;
}