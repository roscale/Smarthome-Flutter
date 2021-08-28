import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class LightModel with ChangeNotifier {
  BluetoothDevice? _bluetoothDevice;
  String? _ipv4Address;
  bool _isConfigured = true;
  String uuid;
  late String name;
  late bool isOn;

  LightModel(this.uuid);

  BluetoothDevice? get bluetoothDevice => _bluetoothDevice;

  set bluetoothDevice(BluetoothDevice? value) {
    _bluetoothDevice = value;
    notifyListeners();
  }

  String? get ipv4Address => _ipv4Address;

  set ipv4Address(String? value) {
    _ipv4Address = value;
    notifyListeners();
  }

  bool get isConfigured => _isConfigured;

  set isConfigured(bool value) {
    _isConfigured = value;
    notifyListeners();
  }

  bool isReachableViaBluetooth() => _bluetoothDevice != null;

  bool isReachableViaWiFi() => _ipv4Address != null;
}
