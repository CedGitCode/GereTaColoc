class Achats {
  int? id;
  String? name;
  double? price;
  List<int>? coloc;

  Achats(this.id, this.name, this.price, this.coloc);

  Achats.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    coloc = json['coloc'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['coloc'] = this.coloc;
    return data;
  }
}
