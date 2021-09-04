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
  Stream<LightInfoWithBluetoothDevice> discoverLights() async* {
    await for (var result in FlutterBluetoothSerial.instance.startDiscovery()) {
      var device = result.device;
      if (device.name == null || !device.name!.startsWith("Smarthome-")) {
        continue;
      }

      BluetoothConnection connection;
      try {
        connection = await BluetoothConnection.toAddress(device.address);
      } catch (e) {
        print(e);
        continue;
      }

      try {
        connection.output.add(Uint8List.fromList('{"info": 0}'.codeUnits));
        await connection.output.allSent;
        Uint8List data = await connection.input!.first;
        connection.finish();

        var infoJson = jsonDecode(utf8.decode(data));
        var lightInfo = LightInfo(infoJson["uuid"], infoJson["name"], infoJson["power_state"]);
        yield LightInfoWithBluetoothDevice(lightInfo, result.device);
      } catch (e) {
        print(e);
        connection.finish();
      }
    }
  }

  Future<void> turn(BluetoothDevice device, bool on) async {
    var connection = await BluetoothConnection.toAddress(device.address);
    try {
      connection.output.add(Uint8List.fromList('{"power_state": ${on ? 1 : 0}}'.codeUnits));
      await connection.output.allSent;
    } catch (e) {
      print(e);
      await connection.finish();
      rethrow;
    }
  }
}
