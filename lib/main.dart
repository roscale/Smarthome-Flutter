import 'package:flutter/material.dart';
import 'package:smarthome/bluetooth_light_controller.dart';
import 'package:smarthome/pages/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:smarthome/providers/light_list.dart';
import 'package:smarthome/wifi_light_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GetIt.I.registerSingleton(BluetoothLightController());
  GetIt.I.registerSingleton(WiFiLightController());

  var lightList = LightList();

  GetIt.I.get<WiFiLightController>().server().listen((lightInfo) {
    var light = lightList.getLight(lightInfo.lightInfo.uuid) ?? lightList.addLight(lightInfo.lightInfo);
    light.ipAddress = lightInfo.ipAddress;
  });

  runApp(SmarthomeApp(lightList));
}

class SmarthomeApp extends StatelessWidget {
  final LightList lightList;

  SmarthomeApp(this.lightList);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smarthome',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.amber,
          brightness: Brightness.dark,
        ).copyWith(secondary: Colors.amberAccent),
      ),
      initialRoute: '/dashboard',
      routes: {
        '/dashboard': (context) => ChangeNotifierProvider.value(
              value: lightList,
              child: Dashboard(),
            ),
      },
    );
  }
}
