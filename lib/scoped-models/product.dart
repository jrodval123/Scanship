import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel extends Model{

  List<Product> _products = [];
  List<Product> _cartProducts = [];
  
  final CollectionReference collectionReference =
      Firestore.instance.collection('products');
  
}