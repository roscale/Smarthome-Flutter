import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:smarthome/light_info.dart';

/// Contains generic light information + bluetooth related stuff.
class LightInfoWithBluetoothDevice {
  LightInfo lightInfo;
  BluetoothDevice bluetoothDevice;

  LightInfoWithBluetoothDevice(this.lightInfo, this.bluetoothDevice);
}

class BluetoothLightController {
  Stream<LightInfoWithBluetoothDevice> discoverLights() {
    var streamController = StreamController<LightInfoWithBluetoothDevice>();
    var futures = <Future>[];

    FlutterBluetoothSerial.instance.startDiscovery().listen((result) {
      var future = () async {
        var device = result.device;
        if (device.name == null || !device.name!.startsWith("Smarthome-")) {
          return;
        }

        BluetoothConnection connection;
        try {
          connection = await BluetoothConnection.toAddress(device.address);
        } catch (e) {
          print(e);
          return;
        }

        try {
          connection.output.add(Uint8List.fromList('{"info": 0}'.codeUnits));
          await connection.output.allSent;
          Uint8List data = await connection.input!.first;
          connection.finish();

          var infoJson = jsonDecode(utf8.decode(data));
          var lightInfo = LightInfo(infoJson["uuid"], infoJson["name"], infoJson["power"]);
          streamController.add(LightInfoWithBluetoothDevice(lightInfo, result.device));
        } catch (e) {
          print(e);
          connection.finish();
        }
      };
      futures.add(future());
    }, onDone: () async {
      await Future.wait(futures);
      streamController.close();
    }, onError: (e) {});

    return streamController.stream;
  }

  Future<void> turn(BluetoothDevice device, bool on) async {
    var connection = await BluetoothConnection.toAddress(device.address);
    try {
      connection.output.add(Uint8List.fromList('{"power": $on}'.codeUnits));
      await connection.output.allSent;
    } catch (e) {
      print(e);
      await connection.finish();
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getWiFiInfo(BluetoothDevice device) async {
    var connection = await BluetoothConnection.toAddress(device.address);
    try {
      connection.output.add(Uint8List.fromList('{"wifi_info": 0}'.codeUnits));
      await connection.output.allSent;
      var data = await connection.input!.first;
      var json = jsonDecode(utf8.decode(data));
      connection.finish();
      return json;
    } catch (e) {
      print(e);
      await connection.finish();
      rethrow;
    }
  }
}
