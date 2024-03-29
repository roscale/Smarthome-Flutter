import 'package:smarthome/bluetooth_light_controller.dart';
import 'package:smarthome/locator.dart';
import 'package:smarthome/providers/light_list.dart';
import 'package:smarthome/wifi_light_controller.dart';

class LightDiscovery {
  Future<void> discoverLights() async {
    var lightList = locator.get<LightList>();
    var wifiLightController = locator.get<WiFiLightController>();
    var bluetoothLightController = locator.get<BluetoothLightController>();

    // Scan wifi
    var wifiScan = wifiLightController.discoverLights().forEach((info) {
      var light = lightList.getLight(info.lightInfo.uuid) ?? lightList.addLight(info.lightInfo);
      light.ipAddress = info.ipAddress;
    });

    // Scan bluetooth
    var bluetoothScan = bluetoothLightController.discoverLights().timeout(Duration(seconds: 5)).forEach((info) {
      var light = lightList.getLight(info.lightInfo.uuid) ?? lightList.addLight(info.lightInfo);
      light.bluetoothDevice = info.bluetoothDevice;
    });

    await Future.wait([wifiScan, bluetoothScan]);
    print("DISCOVERY FINISHED");
  }
}
