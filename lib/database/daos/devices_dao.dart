import 'dart:async';

import 'package:moor_flutter/moor_flutter.dart';
import 'package:smarthome/database/database.dart';
import 'package:smarthome/database/entities/devices.dart';

part 'devices_dao.g.dart';

@UseDao(tables: [Devices])
class DevicesDao extends DatabaseAccessor<MyDatabase> with _$DevicesDaoMixin {
  DevicesDao(MyDatabase db) : super(db);

  Future<List<Device>> findAllDevices() {
    return select(db.devices).get();
  }

  Future<Device> getDeviceByUUID(String uuid) {
    return (select(db.devices)..where((t) => t.uuid.equals(uuid))).getSingle();
  }

  Future<int> turnDevice(int state, String uuid) {
    return (update(db.devices)..where((t) => t.uuid.equals(uuid)))
        .write(DevicesCompanion(powerState: Value(state)));
  }

  Future<int> renameDevice(String name, String uuid) {
    return (update(db.devices)..where((t) => t.uuid.equals(uuid)))
        .write(DevicesCompanion(name: Value(name)));
  }

  Future<int> insertDevice(DevicesCompanion device) {
    return into(db.devices).insert(device);
  }

  Future<int> deleteDevice(String uuid) {
    return (delete(db.devices)..where((t) => db.devices.uuid.equals(uuid)))
        .go();
  }

  Future<bool> updateDevice(DevicesCompanion device) {
    return update(db.devices).replace(device);
  }

  Future<List<Device>> getAllDevices() {
    return select(db.devices).get();
  }

  Stream<List<Device>> getAllDevicesAsStream() {
    return select(db.devices).watch();
  }
}
