
import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel extends Model{

  List<Product> _products = [];
  List<Product> _truckProducts = [];

  int _selectedProductIndex;
  
  final CollectionReference collectionReference =
      Firestore.instance.collection('products');
  
  // Return elements from the product list
  List<Product> get allProducts{
    return List.from(_products);
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

  // Add products to the firestore once it its created
  void addProduct(Product product){
    Firestore.instance.collection('products').document().setData({
      'name': product.name,
      'code': product.code,
      'barcode': product.barcode
    });
    _products.add(product);
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
  // bool get displayCartOnly {
  //   return showOnCart;
  // }

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
  // void toggleDisplayCart() {
  //   showOnCart = !showOnCart;
  //   notifyListeners();
  // }

  //Updates the status of the cart
  // void toggleProductOnCartStatus() {
  //   final bool isCurrentlyOnCart = selectedProduct.onCart;
  //   final bool newOncartStatus = !isCurrentlyOnCart;
  //   final Product updatedProduct = new Product(selectedProduct.name,
  //       selectedProduct.desc, selectedProduct.imgurl, selectedProduct.price);
  //   updatedProduct.onCart = newOncartStatus;
  //   _products[selectedProductIndex] = updatedProduct;
  //   notifyListeners();
  // }

  //Fetches the products stored in the DB and add it to the Products List
  void fetchProducts() {
    final List<Product> fetchedProducts = [];
    collectionReference.getDocuments().then((QuerySnapshot snaphot) {
      snaphot.documents.forEach((document) {
        final Product newProduct = Product(
            document.data['name'],
            document.data['code'],
            document.data['barcode'],
        );
        fetchedProducts.add(newProduct);
      });
      _products = fetchedProducts;
      notifyListeners();
    });
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