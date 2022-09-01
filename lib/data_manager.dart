import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
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


    if(await file.exists())
    {
      _jsonString = await file.readAsString();
      _json = jsonDecode(_jsonString);
      _json.addAll(_newJson);
      _jsonString = jsonEncode(_json);
    }
    else
    {
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
    if(await file.exists()) {
      _jsonString = await file.readAsString();
      _json = jsonDecode(_jsonString);

      _json.forEach((key, value) {
        listViewColocataire.add(value);
      });
    }

    return listViewColocataire;
  }
}