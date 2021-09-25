import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthome/custom_widgets/light.dart';
import 'package:smarthome/light_discovery.dart';
import 'package:smarthome/locator.dart';
import 'package:smarthome/providers/light_list.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    var lightList = context.watch<LightList>();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: locator.get<LightDiscovery>().discoverLights,
        child: ListView.builder(
          itemCount: lightList.lights.length,
          itemBuilder: (_context, index) {
            var light = lightList.lights[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Light(light),
            );
          },
        ),
      ),
    );
  }
}
