import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:smarthome/pages/configuration/ConfigureDevice.dart';

class ConfigureScreen extends StatefulWidget {
  @override
  _ConfigureScreenState createState() => _ConfigureScreenState();
}

class _ConfigureScreenState extends State<ConfigureScreen> {
  var devices = Map<String, BluetoothDevice>();
  bool bluetoothOn = false;
  bool searching = false;

  void discoverDevices() async {
    BluetoothState state = await FlutterBlue.instance.state;
    bluetoothOn = (state == BluetoothState.on);

    if (!bluetoothOn) {
      showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Failed to scan for devices'),
              content: SingleChildScrollView(
                child: Text('Please turn on Bluetooth and refresh.'),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });

      return;
    }

    FlutterBlue.instance
        .scan(timeout: Duration(seconds: 2))
        .listen((scanResult) {
      if (scanResult.advertisementData.serviceUuids
          .contains("b1d109ed-eb34-4421-8780-841efba77469")) {
        devices.putIfAbsent(scanResult.device.id.id, () => scanResult.device);
        setState(() {});
      }
    });

    setState(() {
      searching = true;
    });

    Future.delayed(Duration(seconds: 2))
        .then((_) => setState(() => searching = false));
  }

  @override
  void initState() {
    super.initState();
    discoverDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configure lights"),
        actions: <Widget>[
          FittedBox(
            fit: BoxFit.scaleDown,
            child: searching
                ? CircularProgressIndicator()
                : IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: discoverDevices,
                    tooltip: "Refresh",
                  ),
          )
        ],
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: devices.length,
          itemBuilder: (context, i) {
            var device = devices.values.toList()[i];

            return ListTile(
                leading: Icon(Icons.lightbulb_outline, size: 30,),
                title: Text(device.name),
                subtitle: Text(device.id.id),
                onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => ConfigureDevice(
                          device: device,
                        ))));
          }),
    );
  }
}
