import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smarthome/HomeDrawer.dart';
import 'package:smarthome/blocs/LightBloc.dart';
import 'package:smarthome/custom_widgets/LightBlocProvider.dart';
import 'package:smarthome/db/DatabaseProvider.dart';
import 'package:smarthome/pages/groups/GroupCard.dart';
import 'package:smarthome/pages/lights/LightCard.dart';

class LightsPage extends StatefulWidget {
  @override
  _LightsPageState createState() => _LightsPageState();
}

class _LightsPageState extends State<LightsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),

      appBar: AppBar(
        title: Text("Lights"),
        actions: <Widget>[
          Switch(value: false, onChanged: (_){},)
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("test print");
          Navigator.of(context).pushNamed('/add_lights');
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<LightDTO>>(
          stream: LightBlocProvider.of(context).allLights,
          initialData: [],
          builder: (context, snapshot) {
            print("REBUILDING PAGE ${snapshot.connectionState}");

            return GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.3,
              children: snapshot.data
                  .map((LightDTO dto) => LightCard(key: GlobalKey(),
                        light: dto,
                      ))
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
