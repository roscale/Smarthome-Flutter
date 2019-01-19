import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smarthome/pages/lights/AddLightsScreen.dart';

class AddLightsItem extends StatefulWidget {
  final LightData data;

  AddLightsItem({key, @required this.data}) : super(key: key);

  @override
  _AddLightsItemState createState() => _AddLightsItemState();
}

class _AddLightsItemState extends State<AddLightsItem> {
  LightData data;

  @override
  void initState() {
    data = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.lightbulb_outline,
                      size: 40,
                      color: Colors.amber,
                    ),
                  ),
                  Flexible(
//                    child: TextField(
//                      cursorColor: Colors.grey,
//                      onChanged: (text) {
//                        data.name = text;
//                      },
//                    ),
                    child: Text(data.name),
                  )
                ],
              ),
            ),
            Checkbox(
                value: data.checked,
                activeColor: Colors.amberAccent,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                onChanged: (checked) {
                  setState(() {
                    data.checked = checked;
                  });
                })
          ],
        ),
      ),
    );
    ;
  }
}
