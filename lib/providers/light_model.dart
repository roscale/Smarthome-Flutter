import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get_it/get_it.dart';
import 'package:smarthome/bluetooth_light_controller.dart';
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

  set isOn(bool value) {
    isLoading = true;
    notifyListeners();

    () async {
      if (ipAddress != null) {
        try {
          await GetIt.I.get<WiFiLightController>().turn(ipAddress!, value);
          _isOn = value;
        } catch (e) {
          try {
            await GetIt.I.get<BluetoothLightController>().turn(_bluetoothDevice!, value);
            _isOn = value;
          } catch (e) {}
        } finally {
          isLoading = false;
          notifyListeners();
        }
      }
    }();
  }

  bool isReachableViaBluetooth() => _bluetoothDevice != null;

  bool isReachableViaWiFi() => _ipAddress != null;
}
