import 'package:rxdart/subjects.dart';

import 'package:smarthome/db/DatabaseProvider.dart';

class LightBloc {
  var allLights = BehaviorSubject<List<LightDTO>>(seedValue: []);

  Future fetchAllLights() async {
    var list = await DatabaseProvider.getAllLights();
    allLights.add(list);
  }

  LightBloc() {
    fetchAllLights();
  }
}