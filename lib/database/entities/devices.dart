import 'package:moor_flutter/moor_flutter.dart';

class Devices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text()();
  TextColumn get name => text()();
  TextColumn get ip => text()();
  IntColumn get powerState => integer().named("power_state")();
}