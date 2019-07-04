//Order class

import 'package:scanship/models/product.dart';

class Order{
  
  String id;
  List<Product> products;

  Order(this.id, this.products);

  //Return contents of the products list
  List<Product> get allProducts{
    return List.from(products);
  }

}