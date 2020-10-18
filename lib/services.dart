import 'package:get_it/get_it.dart';
import 'package:smarthome/database/database.dart';

final getIt = GetIt.instance;

void setupServices() {
  getIt.registerSingleton(MyDatabase());
}