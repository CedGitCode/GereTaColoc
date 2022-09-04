import 'dart:convert';
import 'dart:io';
import 'package:gere_ta_coloc/achats_class.dart';
import 'package:gere_ta_coloc/db_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DataManager {

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> getLocalFile(String fileName) async {
    final localPath = await _localPath;
    return File("$localPath/$fileName");
  }

  static void writeColocToJson(String name) async
  {
    File file = await getLocalFile("colocs.json");
    var uuid = Uuid();
    Map<String, dynamic> _json = {};
    Map<String, dynamic> _newJson = {uuid.v4(): name};
    String _jsonString;


    if (await file.exists()) {
      _jsonString = await file.readAsString();
      _json = jsonDecode(_jsonString);
      _json.addAll(_newJson);
      _jsonString = jsonEncode(_json);
    }
    else {
      _jsonString = jsonEncode(_newJson);
    }

    file.writeAsString(_jsonString);
  }

  static Future<List<String>> readColocFromJson() async
  {
    List<String> listViewColocataire = [];
    File file = await getLocalFile("colocs.json");
    Map<String, dynamic> _json = {};
    String _jsonString;
    if (await file.exists()) {
      _jsonString = await file.readAsString();
      _json = jsonDecode(_jsonString);

      _json.forEach((key, value) {
        listViewColocataire.add(value);
      });
    }

    return listViewColocataire;
  }

  static void writeAchatsToJSON(Achats p_achats) async
  {
    File file = await getLocalFile("achats.json");
    Map<String, dynamic> _json = {};
    Map<String, dynamic> _newJson = p_achats.toJson();
    String _jsonString;


    if (await file.exists()) {
      _jsonString = await file.readAsString();
      _json = jsonDecode(_jsonString);
      _json.addAll(_newJson);
      _jsonString = jsonEncode(_json);
    }
    else {
      _jsonString = jsonEncode(_newJson);
    }

    file.writeAsString(_jsonString);
  }

  static void InsertAchats(String name, String price, String colocs) async {
    // get a reference to the database
    // because this is an expensive operation we use async and await
    Database? db = await DatabaseHelper.instance.database;

    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnNameAchats: name,
      DatabaseHelper.columnPriceAchats: price,
      DatabaseHelper.columnColocsAchats: colocs
    };

    // do the insert and get the id of the inserted row
    int? id = await db?.insert(DatabaseHelper.table_achats, row);

    print(await db?.query(DatabaseHelper.table_achats));
  }

  static void InsertColocs(String name) async {
    // get a reference to the database
    // because this is an expensive operation we use async and await
    Database? db = await DatabaseHelper.instance.database;

    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnNameColocs: name
    };

    // do the insert and get the id of the inserted row
    int? id = await db?.insert(DatabaseHelper.table_colocs, row);

    print(await db?.query(DatabaseHelper.table_colocs));
  }

  static void DeleteColocs(String name) async {
    // get a reference to the database
    // because this is an expensive operation we use async and await
    Database? db = await DatabaseHelper.instance.database;

    print(await db?.delete(DatabaseHelper.table_colocs, where: '${DatabaseHelper.columnNameColocs} = ?', whereArgs: [name]));

  }

  static Future<List<Map<String, Object?>>?> fetchColocsFromDB() async{
    Database? db = await DatabaseHelper.instance.database;
    List<Map<String, Object?>>? list = await db?.rawQuery('SELECT ${DatabaseHelper.columnNameColocs} FROM ${DatabaseHelper.table_colocs}');
    return list;
  }
}