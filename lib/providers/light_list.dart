import 'package:flutter/material.dart';
import 'package:smarthome/providers/light_model.dart';

class LightList with ChangeNotifier {
  List<LightModel> lights = [];

  LightModel getOrAddLight(String uuid) {
    try {
      return lights.firstWhere((light) => light.uuid == uuid);
    } on StateError catch (_) {
      var light = LightModel(uuid);
      lights.add(light);
      return light;
    }
  }
}
