import 'package:flutter/material.dart';

class RenameDialog {
  String text = "";

  RenameDialog({required BuildContext context, required Function(String) onRename}) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("Rename"),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  TextField(
                    autofocus: true,
                    onChanged: (text) {
                      this.text = text;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text(
                            'CANCEL',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amberAccent),
                          ),
                          onPressed: Navigator.of(context).pop,
                        ),
                        TextButton(
                          child: const Text(
                            'RENAME',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amberAccent),
                          ),
                          onPressed: () {
                            onRename(text);
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
