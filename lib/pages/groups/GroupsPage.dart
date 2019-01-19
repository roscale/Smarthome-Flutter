import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smarthome/pages/groups/GroupCard.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.3,
        children: <Widget>[
          GroupCard(),
          GroupCard(),
          GroupCard(),
          GroupCard(),
          GroupCard(),
          GroupCard(),
          GroupCard(),
          GroupCard(),
          GroupCard(),
        ],
      ),
    );
  }
}
