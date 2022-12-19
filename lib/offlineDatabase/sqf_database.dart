import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:site_audit/models/DataBaseModel.dart';
import 'package:site_audit/models/form_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

import '../models/sqf_form_model.dart';

class DBHelper {
  static Database? _db;
  static const String TABLE = 'form_table';
  static const String ID = 'id';
  static const String SUBMODULEID = 'sub_module_id';
  static const String SUBMODULENAME = 'sub_module_name';
  static const String MODULENAME = 'module_name';
  static const String PROJECTID = 'project_id';
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'site_audit.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE v4_project_audit_information (id INTEGER PRIMARY KEY AUTOINCREMENT, eng_id INTEGER, form_id INTEGER, hint TEXT NOT NULL, input_type TEXT NOT NULL, label TEXT NOT NULL, mandatory TEXT NOT NULL, value TEXT NOT NULL)"
        // "CREATE TABLE v4_project_audit_information(id INTEGER PRIMARY KEY AUTOINCREAMENT, engineer_id int(11) NOT NULL, project_id int(11) NOT NULL, project_module_id int(11) NOT NULL, module_form_id int(11) NOT NULL, project_active_input_id int(11) NOT NULL, input_type varchar(255) NOT NULL, label text NOT NULL , hint text NOT NULL, mandatory text NOT NULL ,value text NOT NULL, created_at timestamp NOT NULL DEFAULT current_timestamp(), updated_at timestamp NOT NULL DEFAULT current_timestamp()) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
        );
  }

  Future<SqfFormModel> insert(SqfFormModel dbModel) async {
    var dbClient = await db;
    dbClient!.insert('v4_project_audit_information', dbModel.toMap());
    return dbModel;
  }

  Future<List<SqfFormModel>> getNotesList() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('v4_project_audit_information');
    return queryResult.map((e) => SqfFormModel.fromMap(e)).toList();
  }

  Future<int> deleteFunction(int id) async {
    var dbClient = await db;
    return await dbClient!.delete('v4_project_audit_information',
        where: "id = ?", whereArgs: [id]);
  }

  // Future<int> updateFunction(NoteModel noteModel) async {
  //   var dbClient = await db;
  //   return await dbClient!.update('notes', noteModel.toMap(),
  //       where: 'id = ?', whereArgs: [noteModel.id]);
  // }
}
