import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            padding: const EdgeInsets.all(0),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.asset(
                  "assets/images/drawer-header.jpg",
                  fit: BoxFit.fill,
                ),

                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text("Smarthome", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),),
                          ),
//                          Text(university, style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),)
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.tune),
            title: Text("Configure lights"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/configuration');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {
              Navigator.pop(context);
//              Navigator.of(context).pushNamed('/settings');
            },
          ),
          Divider(),
          ListTile(
            title: Text("Help & feedback"),
            onTap: () {},
          ),
          AboutListTile(
            icon: null,
            child: Text("About"),
            applicationName: "Smarthome",
            applicationVersion: "0.0.1a",
            applicationIcon: Icon(Icons.help_outline),
            aboutBoxChildren: <Widget>[
              Text("Smart home lighting control app"),
            ],
          )
        ],
      ),
    );
  }
}
