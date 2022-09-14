import 'dart:io' show Directory;
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;

class DatabaseHelper {

  static final _databaseName = "geretacoloc.db";
  static final _databaseVersion = 1;

  static final table_achats = 'Achats';
  static final table_colocs = 'Colocs';

  static final columnIdAchats = '_id';
  static final columnNameAchats = 'name';
  static final columnPriceAchats = 'price';
  static final columnColocsAchats = 'colocs';

  static final columnIdColocs = '_id';
  static final columnNameColocs = 'name';
  static final columnPriceToPayColocs = 'ptp';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database?> get database async {
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table_achats (
            $columnIdAchats INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnNameAchats TEXT NOT NULL,
            $columnPriceAchats TEXT NOT NULL,
            $columnColocsAchats TEXT NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE $table_colocs (
            $columnIdColocs INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnNameColocs TEXT NOT NULL,
            $columnPriceToPayColocs DOUBLE NOT NULL
          )
          ''');
  }
}