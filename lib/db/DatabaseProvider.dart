import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LightDTO {
  String uuid;
  String ip;
  String name;
  int powerState;

  LightDTO(this.uuid, this.ip, this.name, this.powerState);

  Map<String, dynamic> toMap() => {
        COLUMN_UUID: uuid,
        COLUMN_IP: ip,
        COLUMN_NAME: name,
        COLUMN_POWER_STATE: powerState
      };
}

const DB_FILE = "smarthome.db";
const TABLE_LIGHTS = "Lights";
const COLUMN_ID = "id";
const COLUMN_UUID = "uuid";
const COLUMN_IP = "ip";
const COLUMN_NAME = "name";
const COLUMN_POWER_STATE = "power_state";

class DatabaseProvider {
  static Database db;

  static Future open() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, DB_FILE);

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $TABLE_LIGHTS ( 
  $COLUMN_ID integer primary key autoincrement, 
  $COLUMN_UUID text not null,
  $COLUMN_IP text not null,
  $COLUMN_NAME text not null,
  $COLUMN_POWER_STATE boolean not null)
''');
    });
  }

  static Future<List<LightDTO>> getAllLights() async {
    var records = await db.query(TABLE_LIGHTS);

    print("RECORDS $records");

    return records.map((record) {
      return LightDTO(record[COLUMN_UUID], record[COLUMN_IP],
          record[COLUMN_NAME], record[COLUMN_POWER_STATE]);
    }).toList();
  }

  static Future<LightDTO> getLightByUUID(String uuid) async {
    var records = await db.query(TABLE_LIGHTS,
        where: "$COLUMN_UUID = ?", whereArgs: [uuid], limit: 1);
    if (records.isEmpty) return null;

    var record = records.first;
    return LightDTO(record[COLUMN_UUID], record[COLUMN_IP], record[COLUMN_NAME],
        record[COLUMN_POWER_STATE]);
  }

  static Future<int> turnLight(bool powerState, String uuid) async {
    return await db.update(TABLE_LIGHTS, {COLUMN_POWER_STATE: powerState},
        where: "$COLUMN_UUID = ?", whereArgs: [uuid]);
  }

  static Future<int> turnAllLights(bool powerState) async {
    return await db.update(TABLE_LIGHTS, {COLUMN_POWER_STATE: powerState});
  }

  static Future<int> renameLight(String name, String uuid) async {
    return await db.update(TABLE_LIGHTS, {COLUMN_NAME: name},
        where: "$COLUMN_UUID = ?", whereArgs: [uuid]);
  }

  static Future<LightDTO> insertLight(LightDTO dto) async {
    await db.insert(TABLE_LIGHTS, dto.toMap());
    return dto;
  }

  static Future<int> deleteLight(String uuid) async {
    return await db
        .delete(TABLE_LIGHTS, where: "$COLUMN_UUID = ?", whereArgs: [uuid]);
  }

  static Future close() async => db.close();
}
