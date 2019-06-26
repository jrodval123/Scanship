import 'package:scoped_model/scoped_model.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class ProductModel extends Model {
  List<Product> _products = [];
  List<Product> _truckProducts = [];

  bool onTruck;
  int _selectedProductIndex;
<<<<<<< HEAD

=======
  
  //Firebase DB reference
  final dbref = FirebaseDatabase.instance.reference();

  //FireStore reference
>>>>>>> 543108ebe6cd84558f1cfe33bba6fd38b13ccf12
  final CollectionReference collectionReference =
      Firestore.instance.collection('products');

  // Return elements from the product list
  List<Product> get allProducts {
    return List.from(_products);
  }

  // Return elements from the truck list
  List<Product> get allTruckProducts {
    return List.from(_truckProducts);
  }

  //Add products to the truck
  void addToTruck(Product product) {
    _truckProducts.add(product);
    notifyListeners();
  }

  // Add products to the firestore once it its created
<<<<<<< HEAD
  void addProduct(Product product) {
=======
  void addProduct(Product product){
    dbref.child("1").set({
      'name': product.name,
      'code':product.code,
      'barcode':product.barcode
    });
>>>>>>> 543108ebe6cd84558f1cfe33bba6fd38b13ccf12
    Firestore.instance.collection('products').document().setData({
      'name': product.name,
      'code': product.code,
      'barcode': product.barcode
    });
    _products.add(product);
    print(_products.length);
    notifyListeners();
  }

  int get selectedProductIndex {
    return _selectedProductIndex;
  }

  //Returns a Product of the selected Index
  Product get selectedProduct {
    if (_selectedProductIndex == null) {
      return null;
    }
    return _products[_selectedProductIndex];
  }

  //Returns a boolean to see if the user wants to display the cart products only
  bool get displayCartOnly {
    return onTruck;
  }

  //Updates the product whenever it its editted.
  void updateProduct(String name, String code, String barcode) {
    final Product updatedProduct = Product(name, code, barcode);
    _products[_selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  //Removes a product from the products list
  void deleteProduct() {
    _products.removeAt(_selectedProductIndex);
    _selectedProductIndex = null;
  }

  //Marks the product as the selected product
  void selectProduct(int index) {
    _selectedProductIndex = index;
  }

  //Display only the items on the cart
  void toggleDisplayCart() {
    onTruck = !onTruck;
    notifyListeners();
  }

  //Updates the status of the cart
  void toggleProductOnCartStatus() {
    final bool isCurrentlyOnCart = selectedProduct.loaded;
    final bool newOncartStatus = !isCurrentlyOnCart;
    final Product updatedProduct = new Product(
        selectedProduct.name, selectedProduct.code, selectedProduct.barcode);
    updatedProduct.loaded = newOncartStatus;
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  //Fetches the products stored in the DB and add it to the Products List
  void fetchProducts() {
    final List<Product> fetchedProducts = [];
    collectionReference.getDocuments().then((QuerySnapshot snaphot) {
      snaphot.documents.forEach((document) {
        final Product newProduct = Product(
          document.data['name'],
          document.data['barcode'],
          document.data['code'],
        );
        fetchedProducts.add(newProduct);
        print(fetchedProducts.length);
      });
      _products = fetchedProducts;
      notifyListeners();
    });
    notifyListeners();
  }

  //Fetches the products stored in the DB and adds them to the orders list
  // void fetchOrders() {
  //   List<Order> fetchedOrders = [];
  //   orderCollectionReference.getDocuments().then((QuerySnapshot snapshot) {
  //     snapshot.documents.forEach((document) {
  //       final Order newOrder = Order(
  //         document.data['id'],
  //         document.data['number'].toString(),
  //         document.data['ordertotal'],
  //         document.data['qty']
  //       );
  //       fetchedOrders.add(newOrder);
  //     });
  //     _orders = fetchedOrders;
  //     notifyListeners();
  //   });
  // }
}

class ProductStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/products.txt');
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    return file.writeAsString('$counter');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      return 0;
    }
  }
}
