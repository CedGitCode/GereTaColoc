import 'dart:convert';
import 'dart:io';
import 'package:gere_ta_coloc/article.dart';
import 'package:gere_ta_coloc/colocs_class.dart';
import 'package:gere_ta_coloc/db_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataManager {

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> getLocalFile(String fileName) async {
    final localPath = await _localPath;
    return File("$localPath/$fileName");
  }


  static void InsertAchats(Article article) async {
    // get a reference to the database
    // because this is an expensive operation we use async and await
    Database? db = await DatabaseHelper.instance.database;

    List<String> colocString = [];

    article.colocataire.forEach((key, value) { {
      if(value == true)
        {
          colocString.add(key);
        }
    }
    });
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnNameAchats: article.name,
      DatabaseHelper.columnPriceAchats: article.price,
      DatabaseHelper.columnColocsAchats: colocString.toString().replaceAll('[', '').replaceAll(']','')
    };

    // do the insert and get the id of the inserted row
    int? id = await db?.insert(DatabaseHelper.table_achats, row);

    print(await db?.query(DatabaseHelper.table_achats));
  }

  static void InsertColocs(Colocs colocs) async {
    // get a reference to the database
    // because this is an expensive operation we use async and await
    Database? db = await DatabaseHelper.instance.database;

    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnNameColocs: colocs.name,
      DatabaseHelper.columnPriceToPayColocs: colocs.expensesPerAchats
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
    List<Map<String, Object?>>? list = await db?.query(DatabaseHelper.table_colocs);
    return list;
  }

  static Future<List<Map<String, Object?>>?> fetchAchatsFromDB() async{
    Database? db = await DatabaseHelper.instance.database;
    List<Map<String, Object?>>? list = await db?.query(DatabaseHelper.table_achats);
    return list;
  }

  static void UpdateAchats(Article article) async{

    List<String> colocString = [];

    article.colocataire.forEach((key, value) { {
      if(value == true)
      {
        colocString.add(key);
      }
    }
    });

    Database? db = await DatabaseHelper.instance.database;
    Map<String, dynamic> row = {
      DatabaseHelper.columnColocsAchats: colocString.toString().replaceAll('[', '').replaceAll(']','')
    };
    print(await db?.rawUpdate("UPDATE ${DatabaseHelper.table_achats} SET ${DatabaseHelper.columnColocsAchats} = '${colocString.toString().replaceAll('[', '').replaceAll(']','')}' WHERE ${DatabaseHelper.columnNameAchats} = '${article.name}'"));
      //print(await db?.update(DatabaseHelper.table_achats, row,  where: '${DatabaseHelper.columnNameAchats} = ?', whereArgs: [article.name]));
  }

  static void DeleteAchats(String name) async {
    // get a reference to the database
    // because this is an expensive operation we use async and await
    Database? db = await DatabaseHelper.instance.database;

    print(await db?.delete(DatabaseHelper.table_colocs, where: '${DatabaseHelper.columnNameAchats} = ?', whereArgs: [name]));

  }
}