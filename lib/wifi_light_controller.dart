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
  Stream<LightInfoWithIPAddress> discoverLights() async* {
    // Open the server for incoming connections.
    var serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 9001, shared: true);
    // Let the lights connect to the server for a few seconds before closing.
    Future.delayed(Duration(seconds: 5)).then((_) => serverSocket.close());

    // Announce broadcast.
    var broadcastSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    broadcastSocket.broadcastEnabled = true;
    broadcastSocket.send(Utf8Codec().encode('discovery'), InternetAddress("255.255.255.255"), 9997);
    broadcastSocket.close();

    // Yield light information.
    await for (var socket in serverSocket) {
      debugPrint("CONNECTED");
      Uint8List data = await socket.first;
      var json = jsonDecode(utf8.decode(data));
      debugPrint("RECEIVED from ${socket.remoteAddress} json -> $json");
      var lightInfo = LightInfo(json["uuid"], json["name"], json["power"]);
      yield LightInfoWithIPAddress(lightInfo, socket.remoteAddress.address);
    }
    debugPrint("SERVER CLOSED");
  }

  Future<void> turn(String ipAddress, bool on) async {
    var socket = await Socket.connect(InternetAddress(ipAddress), 8088, timeout: Duration(seconds: 2));
    socket.add(utf8.encode('{"power": $on}'));
    await socket.close();
  }

  Future<Map<String, dynamic>> getWiFiInfo(String ipAddress) async {
    var socket = await Socket.connect(InternetAddress(ipAddress), 8088, timeout: Duration(seconds: 2));
    socket.add(utf8.encode('{"wifi_info": 0}'));
    await socket.flush();
    var data = await socket.first;
    await socket.close();
    return jsonDecode(utf8.decode(data));
  }
}
