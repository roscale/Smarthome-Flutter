import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ConfigureDevice extends StatefulWidget {
  final BluetoothDevice device;

  ConfigureDevice({key, this.device}) : super(key: key);

  @override
  _ConfigureDeviceState createState() => _ConfigureDeviceState();
}

class _ConfigureDeviceState extends State<ConfigureDevice> {
  StreamSubscription<BluetoothDeviceState> deviceConnection;
  BluetoothService service;

  var loading = true;
  var name = "";
  var ssid = "";

  var testInitiated = false;
  var testWaiting = false;
  var testConnected = false;

  var nameController = TextEditingController(text: "");
  var ssidController = TextEditingController(text: "");
  var passwordController = TextEditingController(text: "");

  void gatherInfo() async {
    var flutterBlue = FlutterBlue.instance;

    deviceConnection = flutterBlue.connect(widget.device).listen((s) async {
      if (s == BluetoothDeviceState.connected) {
        var services = await widget.device.discoverServices();
        service = services.singleWhere(
            (s) => s.uuid.toString() == "b1d109ed-eb34-4421-8780-841efba77469");

        for (BluetoothCharacteristic c in service.characteristics) {
          List<int> value;
          try {
            value = await widget.device.readCharacteristic(c);
            print("Charac: $value");
          } catch (e) {
            continue;
            // PlatformException(read_characteristic_error)
            // Apparently not all characteristics can be read
          }

          setState(() {
            switch (c.uuid.toString()) {
              case "8cdceb63-9875-43a1-af5e-eee545068327":
                ssid = String.fromCharCodes(value);
                ssidController.value = TextEditingValue(text: ssid);
                break;
              case "6cba5470-a064-4479-a4e9-c3a3b479d402":
                name = String.fromCharCodes(value);
                nameController.value = TextEditingValue(text: name);
                break;
            }
          });
        }

        setState(() {
          loading = false;
        });
      }
    });

    deviceConnection.onDone(() => deviceConnection.cancel());
  }

  void testConnection() async {
    setState(() {
      testWaiting = true;
    });

    var tx = service.characteristics.singleWhere(
        (c) => c.uuid.toString() == "bc147d05-ecdd-47bb-a2bd-55edaf2bd1e0");

    var rx = service.characteristics.singleWhere(
        (c) => c.uuid.toString() == "0799315c-2ad0-46d4-8070-6fc3539174c2");

    // Listen for response
    await widget.device.setNotifyValue(rx, true);
    widget.device.onValueChanged(rx).listen((value) {
      setState(() {
        testWaiting = false;
        testInitiated = true;
        testConnected = value[0] == 1;
      });
    });

    // Send SSID and PSK for test
    var bytes = "${ssidController.value.text}\n${passwordController.value.text}"
        .codeUnits;

    // Send batch of 19 bytes packets due to BLE protocol limitations
    const nBytes = 19;
    for (var i = 0; i <= bytes.length ~/ nBytes; i++) {
      var start = i * nBytes;
      var end =
          (i + 1) * nBytes <= bytes.length ? (i + 1) * nBytes : bytes.length;
      var flagPacket = (i == (bytes.length ~/ nBytes)) ? 0x02 : 0x01;
      print("FLAG $flagPacket ${bytes.length ~/ nBytes}");

      widget.device.writeCharacteristic(
          tx, [flagPacket].followedBy(bytes.getRange(start, end)).toList());
      await Future.delayed(Duration(milliseconds: 50));
    }
  }

  void saveSettings() async {
    var tx = service.characteristics.singleWhere(
            (c) => c.uuid.toString() == "67643d0a-6033-483b-b18d-271bcc7901b8");

    var bytes =
        "${nameController.value.text}\n${ssidController.value.text}\n${passwordController.value.text}"
            .codeUnits;

    // Send batch of 19 bytes packets due to BLE protocol limitations
    const nBytes = 19;
    for (var i = 0; i <= bytes.length ~/ nBytes; i++) {
      var start = i * nBytes;
      var end =
          (i + 1) * nBytes <= bytes.length ? (i + 1) * nBytes : bytes.length;
      var flagPacket = (i == (bytes.length ~/ nBytes)) ? 0x02 : 0x01;
      print("FLAG $flagPacket ${bytes.length ~/ nBytes}");

      widget.device.writeCharacteristic(
          tx, [flagPacket].followedBy(bytes.getRange(start, end)).toList());
      await Future.delayed(Duration(milliseconds: 50));
    }
  }

  @override
  void initState() {
    super.initState();
    gatherInfo();
  }

  @override
  void dispose() {
    deviceConnection.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name),
        actions: <Widget>[
          FittedBox(
              fit: BoxFit.scaleDown,
              child: loading
                  ? CircularProgressIndicator()
                  : IconButton(
                      icon: Icon(Icons.save),
                      onPressed: () {
                        saveSettings();
                        Navigator.of(context).pop();
                      },
                      tooltip: "Save",
                    ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.info),
                ),
                Text(
                  "Info",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            TextFormField(
                controller: nameController,
                decoration: new InputDecoration(labelText: 'Name')),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.network_wifi),
                  ),
                  Text(
                    "Network",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            TextFormField(
              controller: ssidController,
              decoration: new InputDecoration(labelText: 'SSID'),
            ),
            TextFormField(
                controller: passwordController,
                decoration: new InputDecoration(labelText: 'PSK')),
            Row(
              children: <Widget>[
                testWaiting
                    ? CircularProgressIndicator()
                    : FlatButton(
                        child: Text("Test connection"),
                        onPressed: testConnection,
                        textColor: Colors.amber,
                      ),
                testInitiated && !testWaiting
                    ? Text(
                        testConnected ? "Connected" : "Not connected",
                        style: TextStyle(
                            color: testConnected ? Colors.green : Colors.red),
                      )
                    : Container(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
