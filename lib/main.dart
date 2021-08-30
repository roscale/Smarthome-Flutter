import 'package:flutter/material.dart';
import 'package:smarthome/bluetooth_light_controller.dart';
import 'package:smarthome/pages/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:smarthome/providers/light_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GetIt.I.registerSingleton(BluetoothLightController());

  runApp(SmarthomeApp());
}

class SmarthomeApp extends StatelessWidget {
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
        '/dashboard': (context) => ChangeNotifierProvider(
              create: (_) => LightList(),
              child: Dashboard(),
            ),
      },
    );
  }
}
