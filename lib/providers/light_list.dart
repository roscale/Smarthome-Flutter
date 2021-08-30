import 'package:flutter/material.dart';
import 'package:smarthome/light_info.dart';
import 'package:smarthome/providers/light_model.dart';

class LightList with ChangeNotifier {
  List<LightModel> lights = [];

  LightModel? getLight(String uuid) {
    try {
      return lights.firstWhere((light) => light.uuid == uuid);
    } on StateError catch (_) {
      return null;
    }
  }

  LightModel addLight(LightInfo info) {
    var light = LightModel(info.uuid, info.name, info.powerState == 1);
    lights.add(light);
    notifyListeners();
    return light;
  }
}
