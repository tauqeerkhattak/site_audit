import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:site_audit/models/form_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBHelper {
  static Database? _db;

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
      "CREATE TABLE v4_project_audit_information (id int(11) NOT NULL, engineer_id int(11) NOT NULL, project_id int(11) NOT NULL, project_module_id int(11) NOT NULL, module_form_id int(11) NOT NULL, project_active_input_id int(11) NOT NULL, input_type varchar(255) NOT NULL, label text NOT NULL , hint text NOT NULL, mandatory text NOT NULL ,value text NOT NULL, created_at timestamp NOT NULL DEFAULT current_timestamp(), updated_at timestamp NOT NULL DEFAULT current_timestamp())",
    );
  }

  Future<FormModel> insert(FormModel formModel) async {
    var dbClient = await db;
    await dbClient!.insert('v4_project_audit_information', formModel.toJson());
    return formModel;
  }

  Future<List<FormModel>> getNotesList() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('v4_project_audit_information');
    return queryResult.map((e) => FormModel.fromJson(e)).toList();
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
