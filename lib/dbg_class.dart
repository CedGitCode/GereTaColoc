import 'package:gere_ta_coloc/article.dart';
import 'package:gere_ta_coloc/colocs_class.dart';
import 'package:gere_ta_coloc/math_logic.dart';

class DebugInfos{
  static void printPerColocsExpenses(List <Colocs> colocList)
  {
    colocList.forEach((element) {
      print("${element.name} : ${element.expensesPerAchats}\n");
    });
  }

  static void printTotalPrice(List <Article> articleList)
  {
    print("Total Price : ${MathLogic.getTotalPrice(articleList)}\n");
  }
}