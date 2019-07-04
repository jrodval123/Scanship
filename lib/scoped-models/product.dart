
import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class ProductModel extends Model{

  List<Product> _products = [];
  List<Product> _truckProducts = [];
  List<Order> _orders = [];

  bool onTruck;
  int _selectedProductIndex;
  
  //Firebase DB reference
  final dbref = FirebaseDatabase.instance.reference();

  //FireStore reference
  final CollectionReference collectionReference =
      Firestore.instance.collection('products');
  
  // Return elements from the product list
  List<Product> get allProducts{
    return List.from(_products);
  }
  
  // Return elements from the orders list
  List<Order> get allOrders{
    return List.from(_orders);
  }

  // Return elements from the truck list
  List<Product> get allTruckProducts{
    return List.from(_truckProducts);
  }

  //Add products to the truck
  void addToTruck(Product product){
    _truckProducts.add(product);
    notifyListeners();
  }

  //Add Product to Order list
  void addToOrder(Product product, List<Product> list){
    list.add(product);
    notifyListeners();
  }

  // Add products to the firestore once it its created
  void addProduct(Product product){
    dbref.child("products").push().set({
      'name': product.name,
      'code':product.code,
      'barcode':product.barcode
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
  void updateProduct(
      String name, String code, String barcode) {
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
    final Product updatedProduct = new Product(selectedProduct.name,
        selectedProduct.code, selectedProduct.barcode);
    updatedProduct.loaded = newOncartStatus;
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  //Fetches the products stored in the DB and add it to the Products List
  void fetchProducts() {
    final List<Product> fetchedProducts = [];
    dbref.child("products").once().then((DataSnapshot snap){

      var keys = snap.value.keys;
      var data = snap.value;
      for(var key in keys){
        Product newProduct = Product(data[key]['name'],data[key]['barcode'], data[key]['code']);
        fetchedProducts.add(newProduct);
      }
      notifyListeners();
      _products = fetchedProducts;
    });
  }
  void printsize(){
    print(_products.length);
  }

  String check(String barcode){
    fetchProducts();
    String name ="";
    List<Product> prods = _products;
    for (var prod in prods){
      if(prod.barcode == barcode){
        name = prod.name;
      }
    }
    if(name==""){return "N?A";}
    return name;
  }

  Product checkInList(String barcode){
    fetchProducts();
    List<Product> prods = _products;
    for (var prod in prods){
      if(prod.barcode == barcode){
        return prod;
      }
    }
    return null;
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