import 'package:flutter/material.dart';
import 'package:scanship/scoped-models/product.dart';
import '../models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class OrderPage extends StatefulWidget {
  final ProductModel model;

  OrderPage(this.model);
  State<StatefulWidget> createState() {
    return _OrderPageState(model);
  }
}

class _OrderPageState extends State<OrderPage> {
  ProductModel model;
  _OrderPageState(this.model);

  String barcode = "";
  String name = "";

  List<Product> order = [];
  List<Product> _products = [];
  // Map<String, dynamic> _order = {'key1':1, 'key2':1,'key3':1,'key4':1,'key5':1,'key6':1,'key7':1,};
  Map<String, dynamic> _order = new Map();

  @override
  void initState() {
    super.initState();
    setState(() {
      model.fetchProducts();
    _products = model.allProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OrdenBeta"),
        actions: <Widget>[
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
              padding: EdgeInsets.all(10.0),
              itemBuilder: (BuildContext context, int index) {
                String key = _order.keys.elementAt(index);
                return ListTile(
                  leading: Container(
                    child: Text(_order[key].toString(),
                        style: TextStyle(fontSize: 18)),
                  ),
                  title: Text(
                    '$key',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                );
              },
              itemCount: _order.length,
            ),
          ),
          FlatButton(
            child: Icon(Icons.add, size: 30),
            onPressed: ()=> barcodeScanning(),
          ),
        ],
      ),
    );
  }

  Future barcodeScanning() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        model.fetchProducts();
        _products = model.allProducts;
        this.barcode = barcode;
        for(var prod in _products){
          if(prod.barcode == barcode){
            name = prod.name;
          }
        }
        if(_order.containsKey('$name')){
          setState(() {
            _order['$name']+=1;
          });
          return;
        }
        _order['$name'] =1;       
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
}
