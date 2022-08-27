import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gere_ta_coloc/colocs_class.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> getLocalFile(String fileName) async {
    final localPath = await _localPath;
    return File("$localPath/$fileName");
  }

  static Future<Map<String, dynamic>> readFromFile(String fileName) async {
    String fileContent = 'JSON Futé';
    final file = await getLocalFile(fileName);
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
    final file = await getLocalFile(fileName);
    if(await file.exists())
      {
          final Map<String, dynamic> jsonContent = jsonDecode(file.readAsStringSync());
          jsonObject.forEach((key, value) {
            jsonContent[key] = value;
          });
          return file.writeAsString(jsonEncode(jsonContent));
      }
    else
      {
        return file.writeAsString(jsonEncode(jsonObject));
      }
  }
}
