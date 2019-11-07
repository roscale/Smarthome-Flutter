import 'package:flutter/material.dart';
import 'package:smarthome/blocs/LightBloc.dart';
import 'package:smarthome/custom_widgets/AnimatedStack.dart';
import 'package:smarthome/custom_widgets/LightBlocProvider.dart';
import 'package:smarthome/db/DatabaseProvider.dart';
import 'package:smarthome/pages/configuration/ConfigureScreen.dart';
import 'package:smarthome/pages/lights/AddLightsScreen.dart';
import 'package:smarthome/pages/lights/LightsPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseProvider.open();
  runApp(SmarthomeApp());
}

class SmarthomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LightBlocProvider(
      bloc: LightBloc(),
      child: MaterialApp(
        title: 'Smarthome',
        theme: ThemeData(
          primarySwatch: Colors.amber,
          accentColor: Colors.amberAccent,
          brightness: Brightness.dark,
        ),
        home: Dashboard(),
        routes: {
          '/add_lights': (context) => AddLightsScreen(),
          '/configuration': (context) => ConfigureScreen()
        },
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: [
//            BottomNavigationBarItem(
//                icon: Icon(Icons.home), title: Text("Home")),
            BottomNavigationBarItem(
                icon: Icon(Icons.lightbulb_outline), title: Text("Lights")),
            BottomNavigationBarItem(
                icon: Icon(Icons.flash_on), title: Text("Automation")),
          ]),
      body: AnimatedStack(
        currentIndex: currentIndex,
        children: <Widget>[
//          GroupsPage(),
          LightsPage(),
          Text("Hihi")
        ],
      ),
    );
  }
}
