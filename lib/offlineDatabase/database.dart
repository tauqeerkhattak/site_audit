import 'dart:async';
import 'dart:developer';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/form_model.dart';

class DatabaseDb {
  static Database? _db;
  static const String TABLE = 'form_table';
  static const String MODULEFORMS = 'module_forms';
  static const String INPUTOPTIONS = 'input_options';
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
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  static Future<Database> initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  static Future<void> clearData() async {
    await _db?.delete(TABLE);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute(""" 
    
    create table $INPUTOPTIONS (
    id integer primary key autoincrement,
    item_id integer,
    input_item_parent_id integer,
    input_parent_level integer,
    input_option text 
    )
    
    """);

    await db.execute("""
    CREATE TABLE $TABLE (
    id integer primary key autoincrement,
    form_id integer,
    input_id integer,
    project_id integer,
    sub_module_id integer,
    mandatory integer,
    input_description text,
    input_type text,
    input_parameter text,
    input_length integer,
    input_hint text,
    answer text,
    parent_input_id integer,
    input_label text,
    input_option_id integer,
     createdAt text,
     updatedAt text,
     foreign key (input_option_id) references $INPUTOPTIONS(id)
     )
    """);

    await db.execute("""  CREATE TABLE $MODULEFORMS (
    id integer primary key autoincrement,
    input_id integer,
    project_id integer,
    sub_module_id integer,
    mandatory integer,
    input_description text,
    input_type text,
    input_parameter text,
    input_length integer,
    input_hint text,
    parent_input_id integer,
    input_label text,
    input_option_id integer,
    foreign key (input_option_id) references $INPUTOPTIONS(id)
    )  """);
  }

  Future<void> deleteAllForms() async {
    final dbClient = await db;
    await dbClient?.delete(MODULEFORMS);
    await dbClient?.delete(INPUTOPTIONS);
    await dbClient?.delete(TABLE);
  }

  Future<void> dropAllForms() async {
    final dbClient = await db;
    await dbClient?.rawQuery('DROP TABLE $MODULEFORMS');
    await dbClient?.rawQuery('DROP TABLE $INPUTOPTIONS');
    await dbClient?.rawQuery('DROP TABLE $TABLE');
  }

  Future<bool> saveFormModel(FormModel model, int subModuleId) async {
    try {
      final dbClient = await db;
      if (dbClient != null && model.items != null) {
        for (final item in model.items!) {
          final inputOptionValue = item.inputOption?.first.toSqfFormatData();
          int? id;
          if (inputOptionValue != null) {
            id = await dbClient.insert(INPUTOPTIONS, inputOptionValue);
          }
          final itemValue = item.toSqfFormatData(
            projectId: '${model.projectId}',
            subModuleId: '$subModuleId',
            inputOptionId: id,
          );
          await dbClient.insert(MODULEFORMS, itemValue);
        }
        return true;
      } else {
        throw Exception("dbClient is null");
      }
    } on DatabaseException catch (error) {
      log('MEDSSSAGE: ${error.toString()}');
      return false;
    } catch (e) {
      log('MESSAGE: $e');
      return false;
    }
  }

  Future<bool> updateAnswerModel({
    required FormModel model,
    required int subModuleId,
    required int formId,
  }) async {
    try {
      final dbClient = await db;
      if (dbClient != null) {
        for (Items item in model.items ?? []) {
          log('ANSWER WHILE UPDATE: ${item.answer} ${model.id}');
          // await dbClient.rawUpdate(
          //   'UPDATE $TABLE SET answer = ? WHERE form_id = ?',
          //   ['${item.answer}', '${model.id}'],
          // );
          await dbClient.update(
            TABLE,
            {'answer': '${item.answer}'},
            where: 'form_id = ? AND id = ?',
            whereArgs: [
              model.id,
              item.id,
            ],
          );
        }
        return true;
      } else {
        throw Exception('Db Client is null');
      }
    } catch (e) {
      log('Error updating AnswerModel: $e');
      return false;
    }
  }

  Future<bool> saveAnswerModel(
      FormModel model, int subModuleId, int formId) async {
    try {
      final dbClient = await db;
      if (dbClient != null) {
        for (final item in model.items!) {
          final inputOptionValue = item.inputOption?.first.toSqfFormatData();
          int? id;
          if (inputOptionValue != null) {
            id = await dbClient.insert(INPUTOPTIONS, inputOptionValue);
          }
          final itemValue = item.toAnswerData(
            formId: formId,
            projectId: '${model.projectId}',
            subModuleId: '$subModuleId',
            inputOptionId: id,
          );
          await dbClient.insert(TABLE, itemValue);
        }
        return true;
      } else {
        throw Exception('DB CLient is null');
      }
    } catch (e) {
      log('EXCEPTION IN SAVING ANSWER MODEL: $e');
      return false;
    }
  }

  // Future<bool> insertFormModel(List<dynamic> items) async {
  //   try {
  //     final dbClient = await db;
  //     if (dbClient != null) {
  //       for (final item in items) {
  //         // if (item['input_type'] == "PHOTO") {
  //         //   final base64String = item['answer'];
  //         //   item['photo'] = base64Decode(base64String);
  //         //   item['answer'] = null;
  //         // }
  //         log("$item itemmmmmm");
  //         await dbClient.insert(TABLE, item);
  //       }
  //     } else {
  //       throw Exception("DB CLIENT ISSUE");
  //     }
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<List<dynamic>> getAllForms(int subModuleId) async {
    try {
      final dbClient = await db;
      if (dbClient != null) {
        final rows = await dbClient.rawQuery(
          'SELECT * FROM $MODULEFORMS WHERE sub_module_id = $subModuleId',
        );
        if (rows.isNotEmpty) {
          return rows;
        } else {
          throw Exception('Query returned empty rows');
        }
      } else {
        throw Exception('DB Client is null');
      }
    } catch (e) {
      log("ERROR IN GETTING ALL FORMS: $e");
      return [];
    }
  }

  Future<dynamic> getInputOptionsFromId(int inputOptionId) async {
    try {
      final dbClient = await db;
      if (dbClient != null) {
        final rows = await dbClient.rawQuery(
          'SELECT * FROM $INPUTOPTIONS WHERE id = $inputOptionId',
        );
        if (rows.isNotEmpty) {
          return rows.first;
        } else {
          throw Exception('NO rows found for id: $inputOptionId');
        }
      } else {
        throw Exception('DB Client is null');
      }
    } catch (e) {
      log('ERROR In getInputOptionsFromId: $e');
      return [];
    }
  }

  Future<List<dynamic>> getDistinctByFormId({
    moduleID,
  }) async {
    var dbClient = await db;
    final List<dynamic> items = await dbClient!.rawQuery(
      'SELECT DISTINCT form_id FROM $TABLE WHERE sub_module_id = $moduleID',
    );
    log('LENGTH OF ITEMS ${items.length}');
    return items;
  }

  Future<List<dynamic>> getFormByFormId({required int formId}) async {
    try {
      final dbClient = await db;
      if (dbClient != null) {
        final rows = await dbClient.rawQuery(
          'SELECT * FROM $TABLE WHERE form_id = $formId',
        );
        if (rows.isNotEmpty) {
          return rows;
        } else {
          throw Exception('No rows found by formId: $formId');
        }
      } else {
        throw Exception('Db Client is null');
      }
    } catch (e) {
      log('Error in getting forms by formId: $formId $e');
      return [];
    }
  }
}
