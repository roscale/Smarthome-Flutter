import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthome/providers/light_model.dart';

class Light extends StatelessWidget {
  final LightModel model;

  const Light(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      child: Consumer<LightModel>(
        builder: (context, model, _) {
          return Card(
            child: InkWell(
              onTap: model.isLoading ? null : () => model.isOn = !model.isOn,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline, size: 50),
                    Container(width: 10),
                    Expanded(
                      child: Text(
                        model.name,
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    Container(
                      width: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          model.isReachableViaBluetooth()
                              ? Icon(Icons.bluetooth)
                              : Icon(Icons.bluetooth_disabled, color: Colors.grey),
                          model.isReachableViaWiFi() ? Icon(Icons.wifi) : Icon(Icons.wifi_off, color: Colors.grey),
                        ],
                      ),
                    ),
                    Switch(
                      value: model.isOn,
                      // Disable interaction while data is being sent.
                      onChanged: model.isLoading ? null : (value) => model.isOn = value,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
