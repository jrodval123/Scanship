import 'package:flutter/material.dart';
import 'package:scanship/scoped-models/product.dart';
import '../models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class CreateOrder extends StatefulWidget {
  final ProductModel model;

  CreateOrder(this.model);

  @override
  State<StatefulWidget> createState() {
    return _CreateOrderState(model);
  }
}

class _CreateOrderState extends State<CreateOrder> {
  final ProductModel model;
  String barcode = "";
  String name = "";

  List<Product> order = [];
  Map<String, int> _order = new Map();
  List<Product> _products = [];
  _CreateOrderState(this.model);

  @override
  void initState() {
    model.fetchProducts();
    _products = model.allProducts;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Orden "),
          actions: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.add),
            //   onPressed: ()=>barcodeScanning(),
            // ),
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {},
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key(order[index].name),
                    onDismissed: (DismissDirection direction) {
                      if (direction == DismissDirection.endToStart) {}
                    },
                    background: Container(
                      color: Colors.red,
                    ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Container(
                            child: Text(
                              order[index].qty.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          title: Text(order[index].name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                        Divider(),
                        ListTile(
                          title: Text(_order.toString()),
                        )
                      ],
                    ),
                  );
                },
                itemCount: order.length,
              ),
            ),
            FlatButton(
              onPressed: () => barcodeScanning(),
              child: Icon(
                Icons.add,
                size: 30,
              ),
            ),
          ],
        ));
  }

  Future barcodeScanning() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        model.fetchProducts();
        _products = model.allProducts;
        this.barcode = checkName(barcode);
        final Product prod = getProduct(barcode);
        addToMap(prod);
        addItem(getProduct(barcode));
        // order.add(checkInList(barcode));
        incrementQty(barcode);
        if (this.barcode == "N?A") {}
        // name = model.check(barcode);
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'No camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode = 'Nothing captured.');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  // Adds the product to the Map
  void addToMap(Product product){
    int counter=1;
    if(_order.containsKey(product.name)){
      counter++;
      // _order.update(product.name, product.name = counter);
      _order.update(product.name, (int)=>counter);
    }
    _order[product.name]= counter;
  }
  
  // Increments the quantity of the product beign scanned
  void incrementQty(String barcode) {
    List<Product> prods = order;
    setState(() {
      for (var prod in prods) {
        if (prod.barcode == barcode) {
          prod.qty++;
        }
      }
    });
  }

  // Checks if the scanned barcode is in the list
  bool inList(barcode) {
    List<Product> prods = order;
    for (var prod in prods) {
      if (prod.barcode == barcode) {
        return true;
      }
    }
    return false;
  }

  // Checks the name?
  String checkName(String barcode) {
    model.fetchProducts();
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

  // Checks if a product is in the list
  Product checkInList(String barcode) {
    model.fetchProducts();
    List<Product> prods = _products;
    for (var prod in prods) {
      if (prod.barcode == barcode) {
        return prod;
      }
    }
    return null;
  }

  // Adds the item to the order
  void addItem(Product prod) {
    List<Product> prods = order;
    if (!prods.contains(prod)) {
      prods.add(prod);
      // incrementQty(prod.barcode);
    }
    order = prods;
  }

  // Returns a products by barcode
  Product getProduct(String barcode) {
    List<Product> prods = _products;
    for (int i = 0; i < prods.length; i++) {
      if (prods[i].barcode == barcode) {
        return prods[i];
      }
    }
    return null;
  }
}
