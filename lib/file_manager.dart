import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileManager {

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _getLocalFile(String fileName) async {
    final localPath = await _localPath;
    return File("$localPath/$fileName");
  }

  static Future<Map<String, dynamic>> readFromFile(String fileName) async {
    String fileContent = 'JSON Futé';
    final file = await _getLocalFile(fileName);
    if(await file.exists()){
      try{
        fileContent = await file.readAsString();
      } catch (e) {
        print(e);
      }
    }
    return jsonDecode(fileContent);
  }

  static Future<File> writeJsonToFile(String fileName, Map<String, dynamic> jsonObject) async{
    final file = await _getLocalFile(fileName);
    return file.writeAsString(jsonEncode(jsonObject));
  }
}


/*
import 'dart:convert';
import 'dart:io';

import 'package:gere_ta_coloc/colocs_class.dart';
import 'package:path_provider/path_provider.dart';

class FileManager{
  static FileManager _instance;

  FileManager._internal() {
    _instance = this;
  }

  factory FileManager() => _instance ?? FileManager._internal();

  Future<String?> get _directoryPath async {
    Directory? directory = await getExternalStorageDirectory();
    return directory?.path;
  }

  Future<File> get _colocfile async {
    final path = await _directoryPath;
    return File('$path/colocs.json');
  }

  Future<File> get _achatfile async{
    final path = await _directoryPath;
    return File('$path/achats.json');
  }

  readColocFile() async {
    String fileContent = 'Coloc';

    File file = await _colocfile;

    if(await file.exists()) {
      try {
        fileContent = await file.readAsString();
      } catch (e) {
        print(e);
      }
    }

    return jsonDecode(fileContent);
  }

  writeColocFile(int id, String name) async {
    final Colocs colocs = Colocs('$id', '$name');
  }

}
*/