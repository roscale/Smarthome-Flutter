import 'package:flutter/material.dart';
import 'package:smarthome/locator.dart';
import 'package:smarthome/providers/light_model.dart';
import 'package:smarthome/wifi_light_controller.dart';

class ConfigureWiFi extends StatefulWidget {
  final LightModel lightModel;

  const ConfigureWiFi({Key? key, required this.lightModel}) : super(key: key);

  @override
  State<ConfigureWiFi> createState() => _ConfigureWiFiState();
}

class _ConfigureWiFiState extends State<ConfigureWiFi> {
  var inputDisabled = true;
  var ssid = TextEditingController();
  var password = TextEditingController();

  @override
  void initState() {
    super.initState();

    locator.get<WiFiLightController>().getWiFiInfo(widget.lightModel.ipAddress!).then((value) {
      setState(() {
        ssid.text = value["ssid"];
        password.text = value["psk"];
        inputDisabled = false;
      });
    });

    // var info = NetworkInfo();
    // info.getWifiName().then((name) {
    //   if (name != null) {
    //     ssid.text = name;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configure Wi-Fi"),
        actions: [
          TextButton(
            onPressed: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text("Next"),
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ssid,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Wi-Fi network name",
                ),
              ),
              Container(height: 20),
              TextField(
                controller: password,
                // obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                  hintText: "(unchanged)",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
