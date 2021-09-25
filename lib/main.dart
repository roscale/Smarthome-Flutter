import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthome/light_discovery.dart';
import 'package:smarthome/locator.dart';
import 'package:smarthome/pages/dashboard.dart';
import 'package:smarthome/providers/light_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupServicesAndState();

  locator.get<LightDiscovery>().discoverLights();

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
        '/dashboard': (context) => ChangeNotifierProvider.value(
              value: locator.get<LightList>(),
              child: Dashboard(),
            ),
      },
    );
  }
}
