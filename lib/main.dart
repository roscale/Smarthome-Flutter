import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:smarthome/pages/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Background low power scan in case new lights show up
  FlutterBlue.instance.scan(
    scanMode: ScanMode.lowPower,
  );

  FlutterBlue.instance.scanResults.listen((event) {
    print("results: $event");
  });

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
        '/dashboard': (context) => Dashboard(),
      },
    );
  }
}
