import 'package:flutter/material.dart';

void showNewLightBottomSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("New light", style: TextStyle(fontSize: 30)),
              Container(height: 20),
              Icon(Icons.lightbulb, size: 100),
              Container(height: 20),
              Container(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text("Configure", style: TextStyle(fontSize: 17)),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(17))),
                ),
              ),
            ],
          ),
        );
      });
}
