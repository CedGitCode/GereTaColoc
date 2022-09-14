import 'package:gere_ta_coloc/article.dart';
import 'package:gere_ta_coloc/colocs_class.dart';
import 'package:gere_ta_coloc/data_manager.dart';
import 'package:gere_ta_coloc/db_handler.dart';
import 'package:sqflite/sqflite.dart';

class MathLogic {
  static Future<double> getTotalPrice(List<Article> articlelist) async{

    double finalResult = 0;

    articlelist.forEach((element) {finalResult += double.parse(element.price);});

    return finalResult;
  }

  static Future<int> _countColocsInAchats(Article article) async {
    int colocCounter = 0;
    article.colocataire.forEach((key, value) {
      if(value == true)
        {
          colocCounter++;
        }
    });
    return colocCounter;
  }

  static updateColocOwnExpenses(List<Article> articleList, List<Colocs> colocsList) async{
    int colocsCounter = 0;

    for(int i = 0; i < colocsList.length; i++) {
      colocsList[i].expensesPerAchats = 0;
    }

    articleList.forEach((element) async {
      colocsCounter = await _countColocsInAchats(element);
      element.colocataire.forEach((key, value) {
        if(value == true)
        {
          colocsList.firstWhere((coloc) => coloc.name == key).expensesPerAchats += double.parse(element.price) / colocsCounter.toDouble();
        }
      });
    });

    DataManager.UpdateColocs(colocsList);
  }
}
