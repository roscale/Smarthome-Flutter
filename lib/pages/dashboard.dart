import 'package:flutter/material.dart';
import 'package:smarthome/custom_widgets/new_light_bottom_sheet.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("poate"),
          onPressed: () {
            showNewLightBottomSheet(context);
          },
        ),
      ),
    );
  }
}
