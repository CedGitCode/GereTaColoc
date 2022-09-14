import 'dart:convert';
import 'dart:io';
import 'package:gere_ta_coloc/article.dart';
import 'package:gere_ta_coloc/colocs_class.dart';
import 'package:gere_ta_coloc/db_handler.dart';
import 'package:gere_ta_coloc/math_logic.dart';
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

  static UpdateColocs(List<Colocs> colocs) async{
    Database? db = await DatabaseHelper.instance.database;

    colocs.forEach((element) {
      print(db?.rawUpdate("UPDATE ${DatabaseHelper.table_colocs} SET ${DatabaseHelper.columnPriceToPayColocs} = ${element.expensesPerAchats} WHERE ${DatabaseHelper.columnNameColocs} = '${element.name}'"));
    });
  }

  static  UpdateAchats(List<Article> article) async{

    Database? db = await DatabaseHelper.instance.database;


    article.forEach((element) { {
      List<String> colocString = [];
      element.colocataire.forEach((key, value) { {
        if(value == true)
        {
            colocString.add(key);
        }
      }
      });
      print(db?.rawUpdate("UPDATE ${DatabaseHelper.table_achats} SET ${DatabaseHelper.columnColocsAchats} = '${colocString.toString().replaceAll('[', '').replaceAll(']','').replaceAll(' ', '').replaceAll(',', '-')}' WHERE ${DatabaseHelper.columnNameAchats} = '${element.name}'"));
    }
    });
      //print(await db?.update(DatabaseHelper.table_achats, row,  where: '${DatabaseHelper.columnNameAchats} = ?', whereArgs: [article.name]));
  }

  static UpdateAllData(List <Article> articleList, List<Colocs> colocsList) async{
    await UpdateAchats(articleList);
    await MathLogic.updateColocOwnExpenses(articleList, colocsList);
  }

  static void DeleteAchats(String name) async {
    // get a reference to the database
    // because this is an expensive operation we use async and await
    Database? db = await DatabaseHelper.instance.database;

    print(await db?.delete(DatabaseHelper.table_colocs, where: '${DatabaseHelper.columnNameAchats} = ?', whereArgs: [name]));

  }
}