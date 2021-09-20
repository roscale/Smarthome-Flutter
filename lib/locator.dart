import 'package:get_it/get_it.dart';
import 'package:smarthome/bluetooth_light_controller.dart';
import 'package:smarthome/light_discovery.dart';
import 'package:smarthome/providers/light_list.dart';
import 'package:smarthome/wifi_light_controller.dart';

final locator = GetIt.instance;

void setupServicesAndState() {
  locator.registerSingleton(BluetoothLightController());
  locator.registerSingleton(WiFiLightController());
  locator.registerSingleton(LightList());
  locator.registerSingleton(LightDiscovery());
}
