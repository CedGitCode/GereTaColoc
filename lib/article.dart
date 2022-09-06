import 'package:flutter/material.dart';

class Article extends ChangeNotifier {

  String name;
  String price;
  Map<String, bool> colocataire = {};
  int _numberofColocataire = 0;

  int getColoc() {
    List<bool> nbrColoc = colocataire.values.toList();

    int index = 0;
    for(bool statut in nbrColoc) {
      if (statut == true){
        index++;
      }
    }
    return index;
  }

  int get numberColocataire {
    return _numberofColocataire;
  }

  void updateNumberColocataire() {
    _numberofColocataire = colocataire.length;
    notifyListeners();
  }


  Article(this.name, this.price, this.colocataire) {
    updateNumberColocataire();
  }
}
