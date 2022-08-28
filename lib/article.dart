import 'package:flutter/material.dart';

class Article {

  String name;
  String price;
  Map<String, bool?> colocataire = {};

  Article(this.name, this.price, this.colocataire);
}
