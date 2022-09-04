class Achats {
  List<Product>? product;

  Achats({this.product});

  Achats.fromJson(Map<String, dynamic> json) {
    if (json['product'] != null) {
      product = <Product>[];
      json['product'].forEach((v) {
        product!.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  String? name;
  String? price;
  //List<String>? colocs;

  Product({this.name, this.price}); // , this.colocs

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    //colocs = json['colocs'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    //data['colocs'] = this.colocs;
    return data;
  }
}
