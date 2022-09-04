import 'package:flutter/material.dart';

class Article {

  String name;
  String price;
  Map<String, bool> colocataire = {};

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

  Article(this.name, this.price, this.colocataire);
}
