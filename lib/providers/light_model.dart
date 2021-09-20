import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:smarthome/bluetooth_light_controller.dart';
import 'package:smarthome/locator.dart';
import 'package:smarthome/wifi_light_controller.dart';

class LightModel with ChangeNotifier {
  BluetoothDevice? _bluetoothDevice;
  String? _ipAddress;
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

  String? get ipAddress => _ipAddress;

  set ipAddress(String? value) {
    _ipAddress = value;
    notifyListeners();
  }

  bool get isConfigured => _isConfigured;

  set isConfigured(bool value) {
    _isConfigured = value;
    notifyListeners();
  }

  bool get isOn => _isOn;

  Future<void> turn(bool on) async {
    isLoading = true;
    notifyListeners();

    if (ipAddress != null) {
      // Prioritize Wi-Fi first.
      try {
        await locator.get<WiFiLightController>().turn(ipAddress!, on).timeout(Duration(seconds: 3));
        _isOn = on;
      } catch (_) {
        // Fallback try with bluetooth.
        await locator.get<BluetoothLightController>().turn(_bluetoothDevice!, on).timeout(Duration(seconds: 3));
        _isOn = on;
      } finally {
        isLoading = false;
        notifyListeners();
      }
      return;
    }

    if (bluetoothDevice != null) {
      // Use bluetooth when there is no wifi.
      try {
        await locator.get<BluetoothLightController>().turn(_bluetoothDevice!, on).timeout(Duration(seconds: 3));
        _isOn = on;
      } finally {
        isLoading = false;
        notifyListeners();
      }
      return;
    }

    isLoading = false;
    notifyListeners();
  }

  bool isReachableViaBluetooth() => _bluetoothDevice != null;

  bool isReachableViaWiFi() => _ipAddress != null;
}
