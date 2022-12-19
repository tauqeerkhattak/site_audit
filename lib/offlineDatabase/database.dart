import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:site_audit/models/DataBaseModel.dart';
import 'package:site_audit/models/form_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseDb {
  static Database? _db;
  static const String TABLE = 'form_table';
  static const String ID = 'id';
  static const String SUBMODULEID = 'sub_module_id';
  static const String SUBMODULENAME = 'sub_module_name';
  static const String MODULENAME = 'module_name';
  static const String PROJECTID = 'project_id';
  static const String ITEMLIST = 'items';
  static const String ITEMID = 'id';
  static const String MANDATORY = 'mandatory';
  static const String INPUTDESCRIPTION = 'inputDescription';
  static const String ANSWER = 'answer';
  static const String FILENAME = 'filename';
  static const String INPUTTYPE = 'inputType';
  static const String INPUTPARAMETER = 'inputParameter';
  static const String INPUTLENGTH = 'inputLength';
  static const String INPUTHINT = 'inputHint';
  static const String PARENTUNPUTID = 'parentInputId';
  static const String INPUTLABEl = 'inputLabel';
  static const String INPUTITEMPARENTID = 'inputItemParentId';
  static const String INPUTPARENTLEVEL = 'inputParentLevel';
  static const String INPUTOPTION = 'inputOptions';
  static const String ITEMTABLE = 'item_table';
  static const String OPTIONTABLE = 'option_table';
  static const String DB_NAME = 'formDB';

  Future<Database?> get db async {
    if (null != _db) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE $TABLE ( $ID INTEGER, $SUBMODULEID INTEGER, $SUBMODULENAME TEXT, $MODULENAME TEXT, $PROJECTID INTEGER)",
    );
    await db.execute(
      "CREATE TABLE $ITEMTABLE ( $ITEMID INTEGER,/* $MANDATORY BOOL,*/ $INPUTDESCRIPTION TEXT, $ANSWER TEXT, $FILENAME TEXT, $INPUTTYPE TEXT, $INPUTPARAMETER TEXT, $INPUTLENGTH INTEGER, $INPUTHINT TEXT, $PARENTUNPUTID INTEGER, $INPUTLABEl TEXT)",
    );

    await db.execute(
      "CREATE TABLE $OPTIONTABLE ( $INPUTITEMPARENTID TEXT, $INPUTPARENTLEVEL TEXT, $INPUTOPTION TEXT ARRAY)",
    );
  }

  Future<DataBaseModel> save(
      DataBaseModel dataBaseModel, List<DataBaseItem> dataBaseItem) async {
    var dbClient = await db;
    dataBaseModel.id = await dbClient!.insert(TABLE, dataBaseModel.toMap());
    for (int i = 1; i < dataBaseItem.length; i++) {
      dataBaseItem[i].id =
          await dbClient.insert(ITEMTABLE, dataBaseItem[i].toMap());

      /*if(dataBaseInputOption != null){
        dataBaseInputOption.inputItemParentId = await dbClient.insert(OPTIONTABLE, dataBaseInputOption.toMap());
      }*/
    }
    /*int index = dataBaseModel.items!.length;
    for(int itemIndex = 0 ; itemIndex < index; itemIndex++){
      dbClient.insert(TABLE, formModel.items![itemIndex].toJson());
      int optionIndex = formModel.items![itemIndex].inputOption!.length;
      if(formModel.items![itemIndex].inputOption!.isNotEmpty){
        for(int i = 0 ; i < optionIndex ; i++){
          dbClient.insert(OPTIONTABLE, formModel.items![itemIndex].inputOption![i].toJson());
        }
      }
    }*/
    return dataBaseModel;
  }

  Future<List<DataBaseModel>> getForm() async {
    var dbClient = await db;
    List<Map> maps = await dbClient!.query(TABLE, columns: [
      ID,
      SUBMODULEID,
      SUBMODULENAME,
      MODULENAME,
      PROJECTID,
      ITEMID
    ]);
    List<DataBaseModel>? employees = [];
    if (maps.isNotEmpty) {
      int i;
      for (i = 0; i < maps.length; i++) {
        employees.add(
          DataBaseModel.fromMap(maps[i]),
          //DataBaseModel.fromMap(map[i]).items,
        );
      }
    }
    return employees;
  }
  /*Future<int> createUserPermissions(UserPermissions userPermissions) async {
    final db = await dbProvider.database;
    var result = db.insert(userPermissionsDBTable, userPermissions.mapToDB());
    int index = userPermissions.comLists.length;
    for (int i = 0; i < index; i++) {
      db.insert(userCompaniesTableDB, userPermissions.toDatabaseForCompany(i));
    }
    return result;
  }*/
  /*Future<List<Audio>> getAudios() async {
    var dbClient = await db;
    List<Map> maps = await dbClient!
        .query(TABLE, columns: [ID, NAME, SELECTED.toString(), OLDPATH]);
    List<Audio> employees = [];
    if (maps.length > 0) {
      int i;
      for (i = 0; i < maps.length; i++) {
        employees.add(Audio.fromMap(maps[i]));
      }
    }
    return employees;
  }

  Future<Audio> seeAudios() async {
    var dbClient = await db;
    Map maps = (await dbClient!.query(TABLE,
        columns: [ID, NAME, SELECTED.toString(), OLDPATH])) as Map;
    Audio employees = Audio.fromMap(maps);
    return employees;
  }

  Future<int> delete(String? id) async {
    var dbClient = await db;
    // return await  dbClient!.delete(TABLE,where: '$path = ?',whereArgs: [path]);
    return await dbClient!.delete(TABLE, where: ID + ' = ?', whereArgs: [id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient!.close();
  }*/
}
