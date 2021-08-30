import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get_it/get_it.dart';
import 'package:smarthome/bluetooth_light_controller.dart';

class LightModel with ChangeNotifier {
  BluetoothDevice? _bluetoothDevice;
  String? _ipv4Address;
  bool _isConfigured = true;
  String uuid;
  String name;
  bool _isOn = false;
  bool isLoading = false;

  LightModel(this.uuid, this.name, this._isOn);

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

  bool get isOn => _isOn;

  set isOn(bool value) {
    isLoading = true;
    notifyListeners();
    () async {
      try {
        await GetIt.I.get<BluetoothLightController>().turn(_bluetoothDevice!, value);
        _isOn = value;
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }();
  }

  bool isReachableViaBluetooth() => _bluetoothDevice != null;

  bool isReachableViaWiFi() => _ipv4Address != null;
}
