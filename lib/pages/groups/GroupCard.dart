import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GroupCard extends StatefulWidget {
  bool on;
  GroupCard({key, this.on = false}): super(key: key);

  @override
  _GroupCardState createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  bool on;

  @override
  void initState() {
    super.initState();
    on = widget.on;
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
                    icon: Icon(Icons.home),
                    iconSize: 60,
                    color: on ? Colors.amber : Colors.grey,
                    tooltip: "Toggle",
                    onPressed: () {
                      setState(() {
                        on = !on;
                      });
                    },
                  ),
                  Text("Kitchen")
                ]),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: PopupMenuButton<String>(
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    child: Text("Rename"),
                  ),
                  PopupMenuItem<String>(
                    child: Text("Delete"),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
