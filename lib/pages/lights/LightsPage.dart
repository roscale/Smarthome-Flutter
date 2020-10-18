import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smarthome/HomeDrawer.dart';
import 'package:smarthome/database/database.dart';
import 'package:smarthome/pages/lights/LightCard.dart';
import 'package:smarthome/services.dart';

class LightsPage extends StatefulWidget {
  @override
  _LightsPageState createState() => _LightsPageState();
}

class _LightsPageState extends State<LightsPage> {
  MyDatabase db = getIt<MyDatabase>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        title: Text("Lights"),
        actions: <Widget>[
          Switch(
            value: false,
            onChanged: (_) {},
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add_lights');
        },
        tooltip: 'Add devices',
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<Device>>(
          stream: db.devicesDao.getAllDevicesAsStream(),
          initialData: [],
          builder: (context, snapshot) {
            return GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.3,
              children: snapshot.data
                  .map((Device d) => LightCard(
                        key: GlobalKey(),
                        light: d,
                      ))
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
