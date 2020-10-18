import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smarthome/pages/configuration/ConfigureScreen.dart';
import 'package:smarthome/pages/lights/AddLightsScreen.dart';
import 'package:smarthome/pages/lights/LightsPage.dart';
import 'package:smarthome/services.dart';
import 'package:udp/udp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServices();
  var receiver = await UDP.bind(Endpoint.broadcast(port: Port(1234)));

  // receiving/listening
  receiver.listen(
    (datagram) {
      var str = String.fromCharCodes(datagram.data);
      if (str == "heartbeat") {
        Socket.connect(datagram.address, 8088).then((socket) async {
          socket.add(Utf8Codec().encode("stay_on"));
          await socket.close();
        });
      }
    },
    timeout: Duration(days: 365),
  );

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

  var bottomSheetOpened = false;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    if () {
//      FlutterBlue.instance.stopScan();
//    }

    // FIXME start the scan only once
    // FlutterBlue.instance
    //     .scan(timeout: Duration(days: 365))
    //     .listen((scanResult) async {
    //   if (scanResult.advertisementData.serviceUuids
    //           .contains("b1d109ed-eb34-4421-8780-841efba77469") &&
    //       scanResult.device.name == "Prototype") {
    //     print(bottomSheetOpened);
    //     if (!bottomSheetOpened) {
    //       setState(() {
    //         bottomSheetOpened = true;
    //       });
    //       var a = await showModalBottomSheet(
    //           context: context,
    //           builder: (context) {
    //             return Center(child: Text(scanResult.device.name));
    //           });
    //       print("BOJ: $a");
    //       setState(() {
    //         bottomSheetOpened = false;
    //       });
    //     }
    //   }
    // });

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
                icon: Icon(Icons.lightbulb_outline), label: "Lights"),
            BottomNavigationBarItem(
                icon: Icon(Icons.flash_on), label: "Automation"),
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
