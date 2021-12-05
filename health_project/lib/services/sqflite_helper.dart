import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:health_project/commons/utils/time_util.dart';
import 'package:health_project/models/activitiy_dto.dart';
import 'package:health_project/models/event_dto.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class SQFLiteHelper {
  static late Database _database;
  static const String DATABASE_NAME = 'HealthProject.db';
  static const String CALENDAR_TABLE = "CalendarTable";
  static const String ACTIVITY_TABLE = 'ActivityTable';

  const SQFLiteHelper._privateConsrtructor();

  static final SQFLiteHelper _instance = SQFLiteHelper._privateConsrtructor();
  static SQFLiteHelper get instance => _instance;

  Future<Database> get database async {
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, DATABASE_NAME);
    // print('path DB: $path');
    Database database =
        await openDatabase(path, version: 2, onCreate: _onCreate);
    return database;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $CALENDAR_TABLE (id PRIMARYKEY INTEGER, status TEXT, content TEXT, timeCreated TEXT, workLocation TEXT, phone TEXT, avatar TEXT, timeEvent TEXT, title TEXT, doctorId INTEGER, patientId INTEGER, email TEXT, latitude TEXT, dfirstname TEXT, dlastname TEXT, longtitude TEXT)');
    await db.execute(
        'CREATE TABLE $ACTIVITY_TABLE (id PRIMARYKEY TEXT, accountId INTEGER, step INTEGER, meter INTEGER, calorie INTEGER, dateTime TEXT)');
    //
  }

  Future<void> close() async {
    var dbClient = await database;
    dbClient.close();
  }

  Future<void> insertCalendar(EventDTO dto) async {
    Database dbClient = await database;
    try {
      await dbClient.insert(CALENDAR_TABLE, dto.toJson());
    } catch (e) {
      print('ERROR AT Insert Calendar to SQFLITE $e');
    }
  }

  ///
  ///CALENDAR - EVENT
  //
  Future<List<EventDTO>> getListCalendar(int accountId) async {
    Database dbClient = await database;
    List<EventDTO> list = [];
    try {
      var maps = await dbClient.rawQuery(
          'SELECT * FROM $CALENDAR_TABLE WHERE patientId = $accountId');
      if (maps.isNotEmpty) {
        list = await compute(parseToEventDTO, maps);
      }
    } catch (e) {
      print('ERROR at get list calendar from SQFLITE $e');
    }
    return list;
  }

  //parse Json to EventDTO. Contains 'static' for using thread
  static List<EventDTO> parseToEventDTO(var resBody) {
    final data = jsonDecode(resBody).cast<Map<String, dynamic>>();
    return data.map<EventDTO>((json) => EventDTO.fromJson(json)).toList();
  }

  ///
  ///HEALTH - ACTIVITY
  //
  // insert/update activity value into sqflite
  Future<void> addActivity(ActivityDTO dto) async {
    Database dbClient = await database;
    try {
      //Get last time in db. If it's not null, do update. Another one for doing insert.
      var maps = await dbClient.rawQuery(
          'SELECT * FROM $ACTIVITY_TABLE WHERE accountId = ${dto.accountId} ORDER BY dateTime DESC LIMIT 1');
      if (maps.isNotEmpty) {
        ActivityDTO activityDTO = ActivityDTO.fromJson(maps.first);
        //check record that is same date or not
        //do update
        if (TimeUtil.instance.isSameDate(activityDTO.dateTime)) {
          await dbClient.rawUpdate('''
       UPDATE $ACTIVITY_TABLE 
       SET step = ?, meter = ?, calorie = ?, dateTime = ? 
       WHERE id = ?
       ''', [
            dto.step,
            dto.meter,
            dto.calorie,
            dto.dateTime,
            activityDTO.id,
          ]);
        } else {
          await dbClient.insert(ACTIVITY_TABLE, dto.toJson());
        }
      } else {
        await dbClient.insert(ACTIVITY_TABLE, dto.toJson());
      }
    } catch (e) {
      print('Error at addActivity: $e');
    }
  }

  //get List activity last 7 days
  Future<List<ActivityDTO>> getListActivity(int accountId) async {
    Database dbClient = await database;
    List<ActivityDTO> activityList = [];
    try {
      var maps = await dbClient.rawQuery(
          'SELECT * FROM $ACTIVITY_TABLE WHERE accountId = $accountId ORDER BY dateTime DESC LIMIT 7');
      if (maps.isNotEmpty) {
        activityList = await compute(parseToActivityDTO, maps);
      }
    } catch (e) {
      print('Error at get List Activity: $e');
    }
    return activityList;
  }

  //parse Json to ActivityDTO. Contains 'static' for using thread
  static List<ActivityDTO> parseToActivityDTO(var resBody) {
    List<ActivityDTO> list = [];
    if (resBody.length > 0) {
      for (int i = 0; i < resBody.length; i++) {
        list.add(ActivityDTO.fromJson(resBody[i]));
      }
    }
    return list;
  }
}
