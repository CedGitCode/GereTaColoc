import 'package:flutter/material.dart';

class Article {

  String name;
  String price;
  Map<String, dynamic?> colocataire = {};

  Article(this.name, this.price, this.colocataire);
}
