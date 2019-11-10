import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:smarthome/database/database.dart';
import 'package:smarthome/pages/lights/AddLightsItem.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class LightData {
  String uuid;
  String name;
  String ip;
  int powerState;

  bool checked = true;

  LightData(this.uuid, this.name, this.ip, this.powerState);
}

class AddLightsScreen extends StatefulWidget {
  @override
  _AddLightsScreenState createState() => _AddLightsScreenState();
}

class _AddLightsScreenState extends State<AddLightsScreen> {
  MyDatabase db = kiwi.Container().resolve<MyDatabase>();
  ServerSocket serverSocket;
  List<LightData> lights = [];
  bool searching = true;

  void beginSearch() {
    setState(() {
      searching = true;
    });

    Future.delayed(Duration(seconds: 2))
        .then((_) {
          if (mounted) {
            setState(() => searching = false);
          }
        });

    Fluttertoast.showToast(
      msg: "Searching lights...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 2,
    );

    sendDiscoverySignal();
  }

  Future discoverLights() async {
    ServerSocket.bind(InternetAddress.anyIPv4, 9001).then((serverSocket) {
      this.serverSocket = serverSocket;

      serverSocket.listen((socket) {
        debugPrint("CONNECTED");

        socket.listen((data) async {
          debugPrint("RECEIVED from ${socket.remoteAddress} data -> $data");
          Map<String, dynamic> json = jsonDecode(utf8.decoder.convert(data));

          var light = LightData(json["uuid"], json["name"],
              socket.remoteAddress.address, json["power_state"]);

          // If the device isn't already added
          if (await db.devicesDao.getDeviceByUUID(json["uuid"]) == null) {
            setState(() {
              lights.add(light);
              debugPrint("LIGHT ${light.uuid} ${json["power_state"]}");
            });
          }
        });
      });
    });
  }

  void sendDiscoverySignal() {
    RawDatagramSocket.bind(InternetAddress.anyIPv4, 0).then((socket) {
      socket.broadcastEnabled = true;
      var written = socket.send(Utf8Codec().encode("discovery"),
          InternetAddress("192.168.0.255"), 9997);
      debugPrint("descovery sent $written");
      socket.close();
    });
  }

  void addSelectedLights() async {
    lights.where((light) => light.checked).forEach((light) async {
      db.devicesDao.insertDevice(DevicesCompanion(
          uuid: Value(light.uuid),
          name: Value(light.name),
          ip: Value(light.ip),
          powerState: Value(light.powerState),
      ));
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    discoverLights();
    beginSearch();

    super.initState();
  }

  @override
  void dispose() {
    if (serverSocket != null) {
      serverSocket.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Lights"),
        actions: <Widget>[
          FittedBox(
            fit: BoxFit.scaleDown,
            child: searching
                ? CircularProgressIndicator()
                : FlatButton(
                    child: Text(lights.isNotEmpty ? "Add" : "Retry"),
                    onPressed:
                        lights.isNotEmpty ? addSelectedLights : beginSearch,
                  ),
          )
        ],
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: lights.length,
          itemBuilder: (context, i) {
            return AddLightsItem(
              data: lights[i],
            );
          }),
    );
  }
}
