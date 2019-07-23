import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class ProductModel extends Model {
  List<Product> _products = [];
  List<Product> _truckProducts = [];
  List<Order> _orders = [];

  bool onTruck;
  int _selectedProductIndex;
  int _selectedOrderIndex;
  //Firebase DB reference
  final dbref = FirebaseDatabase.instance.reference();

  //FireStore reference
  final CollectionReference collectionReference =
      Firestore.instance.collection('products');

  // Return elements from the product list
  List<Product> get allProducts {
    return List.from(_products);
  }

  // Return elements from the orders list
  List<Order> get allOrders {
    return List.from(_orders);
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

  //Add Product to Order list
  void addToOrder(Product product, List<Product> list) {
    list.add(product);
    notifyListeners();
  }

  // Add products to the firestore once it its created
  void addProduct(Product product) {
    dbref.child("products").push().set({
      'name': product.name,
      'code': product.code,
      'barcode': product.barcode
    });
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

  int get selectedOrderIndex {
    return _selectedOrderIndex;
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

  void selectOrder(int index) {
    _selectedOrderIndex = index;
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
    dbref.child("products").once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;
      for (var key in keys) {
        Product newProduct =
            Product(data[key]['name'], data[key]['barcode'], data[key]['code']);
        fetchedProducts.add(newProduct);
      }
      notifyListeners();
      _products = fetchedProducts;
    });
  }

  void printsize() {
    print(_products.length);
  }

  String check(String barcode) {
    fetchProducts();
    String name = "";
    List<Product> prods = _products;
    for (var prod in prods) {
      if (prod.barcode == barcode) {
        name = prod.name;
      }
    }
    if (name == "") {
      return "N?A";
    }
    return name;
  }

  Product checkInList(String barcode) {
    fetchProducts();
    List<Product> prods = _products;
    for (var prod in prods) {
      if (prod.barcode == barcode) {
        return prod;
      }
    }
    return null;
  }

  //Pushes the order to the realtime database
  void pushOrder(Order order) {
    var list = order.map.keys.toList();
    var orderRoot = dbref.child('orders');
    var ordersRef = orderRoot.push();
    ordersRef.set({
      'id': order.id,
      'conductor': order.driver,
      'camion': order.truck,
    });
    // var opRef = ordersRef.child('products').push();
    // order.map.forEach((k,v)=>opRef.set({
    //   'name':'$k',
    //   'qty': 'v'
    // }));
    for (int i = 0; i < list.length; i++) {
      var opRef = ordersRef.child('products').push();
      opRef.set({
      'name': list[i], 
      'qty': order.map[list[i]]});
    }
  }

  // Fetches the Orders in the Firebase Realtime Database
  void fetchOrders() {
    final List<Order> fetchedOrders = [];
    // final Map<String, dynamic> map = new Map();
    dbref.child('orders').once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;
      for (var key in keys) {
        Map<String, dynamic> map = new Map();
        dbref.child('orders').child(key).child('products').once().then((DataSnapshot dataSnapshot){
          var _keys = dataSnapshot.value.keys;
          var _data = dataSnapshot.value;
          for(var _key in _keys){
            map[_data[_key]['name']] = _data[_key]['qty'];
          }
        });
        Order newOrder = Order(data[key]['id'], map,
            data[key]['conductor'], data[key]['camion']);
        fetchedOrders.add(newOrder);
      }
      notifyListeners();
      _orders = fetchedOrders;
    });
  }
}
