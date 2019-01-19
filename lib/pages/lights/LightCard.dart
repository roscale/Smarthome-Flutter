import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smarthome/custom_widgets/LightBlocProvider.dart';
import 'package:smarthome/db/DatabaseProvider.dart';
import 'package:smarthome/custom_widgets/RenameDialog.dart';

class LightCard extends StatefulWidget {
  final LightDTO light;

  LightCard({key, this.light}) : super(key: key);

  @override
  _LightCardState createState() => _LightCardState();
}

class _LightCardState extends State<LightCard> {
  LightDTO light;

  @override
  void initState() {
    super.initState();
    light = widget.light;
  }

  void toggleLight() {
    setState(() {
      light.powerState = 1 - light.powerState;
      DatabaseProvider.turnLight(light.powerState == 1, light.uuid);

      Socket.connect(InternetAddress(light.ip), 8088).then((socket) {
        socket.add(Utf8Codec().encode(light.powerState == 1 ? "on" : "off"));
        socket.close();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: <Widget>[
          Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.lightbulb_outline),
                    iconSize: 60,
                    color: light.powerState == 1 ? Colors.amber : Colors.grey,
                    tooltip: "Toggle",
                    onPressed: toggleLight,
                  ),
                  Text(light.name)
                ]),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: PopupMenuButton<String>(
                itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: "rename",
                        child: Text("Rename"),
                      ),
                      PopupMenuItem<String>(
                        value: "delete",
                        child: Text("Delete"),
                      )
                    ],
                onSelected: (value) async {
                  switch (value) {
                    case "rename":
                      RenameDialog(
                          context: context,
                          onRename: (name) {
                            setState(() {
                              light.name = name;
                            });
                            DatabaseProvider.renameLight(
                                light.name, light.uuid);
                            Navigator.of(context).pop();
                          });
                      break;
                    case "delete":
                      await DatabaseProvider.deleteLight(light.uuid);
                      LightBlocProvider.of(context).fetchAllLights();
                      break;
                  }
                },
              ))
        ],
      ),
    );
  }
}
