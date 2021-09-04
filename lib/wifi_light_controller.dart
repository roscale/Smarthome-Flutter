import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:smarthome/light_info.dart';

/// Contains generic light information + wifi related stuff.
class LightInfoWithIPAddress {
  LightInfo lightInfo;
  String ipAddress;

  LightInfoWithIPAddress(this.lightInfo, this.ipAddress);
}

class WiFiLightController {
  void discoverLights() {
    RawDatagramSocket.bind(InternetAddress.anyIPv4, 0).then((socket) {
      socket.broadcastEnabled = true;
      socket.send(Utf8Codec().encode('discovery'), InternetAddress("255.255.255.255"), 9997);
      socket.close();
    });
  }

  Stream<LightInfoWithIPAddress> server() async* {
    var serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 9001);

    await for (var socket in serverSocket) {
      debugPrint("CONNECTED");
      Uint8List data = await socket.first;
      debugPrint("RECEIVED from ${socket.remoteAddress} data -> $data");
      var json = jsonDecode(utf8.decode(data));
      var lightInfo = LightInfo(json["uuid"], json["name"], json["power_state"]);
      yield LightInfoWithIPAddress(lightInfo, socket.remoteAddress.address);
    }
  }

  Future<void> turn(String ipAddress, bool on) async {
    var socket = await Socket.connect(InternetAddress(ipAddress), 8088, timeout: Duration(seconds: 2));
    socket.add(utf8.encode(on ? "on" : "off"));
    await socket.close();
  }
}
