import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:smarthome/database/database.dart';
import 'package:smarthome/pages/configuration/ConfigureScreen.dart';
import 'package:smarthome/pages/lights/AddLightsScreen.dart';
import 'package:smarthome/pages/lights/LightsPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  kiwi.Container().registerInstance(MyDatabase());
  runApp(SmarthomeApp());
}

class SmarthomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smarthome',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        accentColor: Colors.amberAccent,
        brightness: Brightness.dark,
      ),
      initialRoute: "/dashboard",
      routes: {
        '/dashboard': (context) => Dashboard(),
        '/add_lights': (context) => AddLightsScreen(),
        '/configuration': (context) => ConfigureScreen()
      },
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int navbarIndex = 0;
  var pageController = PageController();

  var pages = [LightsPage(), Center(child: Text("TODO"))];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: navbarIndex,
          onTap: (index) {
            setState(() {
              navbarIndex = index;
            });
            pageController.animateToPage(index,
                duration: Duration(milliseconds: 200), curve: Curves.ease);
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.lightbulb_outline), title: Text("Lights")),
            BottomNavigationBarItem(
                icon: Icon(Icons.flash_on), title: Text("Automation")),
          ]),
      body: PageView(
        controller: pageController,
        children: pages,
        onPageChanged: (i) {
          setState(() {
            navbarIndex = i;
          });
        },
      ),
    );
  }
}
