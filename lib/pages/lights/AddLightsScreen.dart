import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smarthome/custom_widgets/LightBlocProvider.dart';
import 'package:smarthome/db/DatabaseProvider.dart';
import 'package:smarthome/pages/lights/AddLightsItem.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LightData {
  String uuid;
  String name;
  String ip;
  bool powerState;

  bool checked = true;

  LightData(this.uuid, this.name, this.ip, this.powerState);
}

class AddLightsScreen extends StatefulWidget {
  @override
  _AddLightsScreenState createState() => _AddLightsScreenState();
}

class _AddLightsScreenState extends State<AddLightsScreen> {
  ServerSocket serverSocket;
  List<LightData> lights = [];
  bool searching = true;

  void beginSearch() {
    setState(() {
      searching = true;
    });

    Future.delayed(Duration(seconds: 2))
        .then((_) => setState(() => searching = false));

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

        socket.transform(utf8.decoder).listen((data) async {
          debugPrint("RECEIVED from ${socket.remoteAddress} data -> $data");
          Map<String, dynamic> json = jsonDecode(data);

          var light = LightData(json["uuid"], json["name"],
              socket.remoteAddress.address, json["power_state"] == 1);

          if (await DatabaseProvider.getLightByUUID(json["uuid"]) == null) {
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
      await DatabaseProvider.insertLight(
          LightDTO(light.uuid, light.ip, light.name, light.powerState ? 1 : 0));
    });
    LightBlocProvider.of(context).fetchAllLights();
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
