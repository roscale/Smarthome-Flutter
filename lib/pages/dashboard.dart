import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:smarthome/bluetooth_light_controller.dart';
import 'package:smarthome/custom_widgets/light.dart';
import 'package:provider/provider.dart';
import 'package:smarthome/providers/light_list.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    var lightList = context.watch<LightList>();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              // Scan bluetooth
              await for (var info in GetIt.I.get<BluetoothLightController>().discoverLights()) {
                var light = lightList.getLight(info.lightInfo.uuid) ?? lightList.addLight(info.lightInfo);
                light.bluetoothDevice = info.bluetoothDevice;
              }

              // Scan wifi
              // TODO
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: lightList.lights.length,
        itemBuilder: (_context, index) {
          var light = lightList.lights[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Light(light),
          );
        },
      ),
    );
  }
}
