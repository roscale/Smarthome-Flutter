import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:smarthome/custom_widgets/RenameDialog.dart';
import 'package:smarthome/database/database.dart';

class LightCard extends StatefulWidget {
  final Device light;

  LightCard({key, this.light}) : super(key: key);

  @override
  _LightCardState createState() => _LightCardState();
}

class _LightCardState extends State<LightCard> {
  MyDatabase db = kiwi.Container().resolve<MyDatabase>();
  DevicesCompanion light;

  @override
  void initState() {
    super.initState();
    light = widget.light.createCompanion(true);
  }

  void toggleLight() {
    setState(() {
      light =
          light.copyWith(powerState: moor.Value(1 - light.powerState.value));

      db.devicesDao.turnDevice(light.powerState.value, light.uuid.value);

      Socket.connect(InternetAddress(light.ip.value), 8088)
          .then((socket) async {
        socket.add(
            Utf8Codec().encode(light.powerState.value == 1 ? "on" : "off"));
        await socket.flush();
        await socket.close();
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
                    color: light.powerState.value == 1
                        ? Colors.amber
                        : Colors.grey,
                    tooltip: "Toggle",
                    onPressed: toggleLight,
                  ),
                  Text(light.name.value)
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
                              light = light.copyWith(name: moor.Value(name));
                            });

                            db.devicesDao.updateDevice(light);
                            Navigator.of(context).pop();
                          });
                      break;
                    case "delete":
                      db.devicesDao.deleteDevice(light.uuid.value);
                      break;
                  }
                },
              ))
        ],
      ),
    );
  }
}
